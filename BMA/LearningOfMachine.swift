 func machineLearning (inout #model: Model, #pairs : [Pair])
 {
    var normM2Sout = 0.0; var normM2Zout = 0.0
    var normP1r = 0.0; var normP2r = 0.0
    
    //  1-2             INITIALIZATION
    let n = count(model.M1.Slayer)
    let k = count(model.M2.Slayer)
    let m = count(model.M2.Ylayer)
    
    //  3   (4-22)      FOR EACH PAIR
    for r in 0..<pairs.count {
        model.addPair(pairs[r])
        //  4               Sout.   (Imax/Imin) in ADDITION OF NEW PAIR
        model.M1.Slayer = model.pairs.last!.arrayS1
        model.M2.Slayer = model.pairs.last!.arrayS2
        
        //  5   (6-17)      FOR EACH ROUND
        //  6               Zin. normM2Sout
        for i in 0..<n {
            model.M1.M11.Zlayer[i].Uin = model.M1.Slayer[i].Uout / model.pairs[r].pairImaxM1!
            model.M1.M12.Zlayer[i].Uin = model.M1.Slayer[i].Uout / model.pairs[r].pairIminM1!
        }
        normM2Sout = 0.0
        for l in 0..<k {
            normM2Sout += model.M2.Slayer[l].Uout
            model.M2.Zlayer[l].Uin = model.M2.Slayer[l].Uout
        }
        
        //  7               Zout
        for i in 0..<n {
            model.M1.M11.Zlayer[i].Uout = model.M1.M11.Zlayer[i].Uin
            model.M1.M12.Zlayer[i].Uout = model.M1.M12.Zlayer[i].Uin
        }
        for l in 0..<k {
            model.M2.Zlayer[l].Uout = model.M2.Zlayer[l].Uin
        }
        
        //  8               Yout
        for j in 0..<m {
            if model.M1.M11.Ylayer[j].Uout != -1 {
                model.M1.M11.Ylayer[j].Uout = 0
                if model.M1.M12.Ylayer[j].Uout != -1 {
                    model.M1.M12.Ylayer[j].Uout = 0
                    for i in 0..<n {
                        model.M1.M11.Ylayer[j].Uout += model.M1.M11.bLinks[i,j] * model.M1.M11.Zlayer[i].Uout
                        model.M1.M12.Ylayer[j].Uout += model.M1.M12.bLinks[i,j] * model.M1.M12.Zlayer[i].Uout
                    }
                }
                else {
                    for i in 0..<n {
                        model.M1.M11.Ylayer[j].Uout += model.M1.M11.bLinks[i,j] * model.M1.M11.Zlayer[i].Uout
                    }
                }
            }
            else if model.M1.M12.Ylayer[j].Uout != -1 {
                model.M1.M12.Ylayer[j].Uout = 0
                for i in 0..<n {
                    model.M1.M12.Ylayer[j].Uout += model.M1.M12.bLinks[i,j] * model.M1.M12.Zlayer[i].Uout
                }
            }
        }
        for g in 0..<m {
            if model.M2.Ylayer[g].Uout != -1 {
                model.M2.Ylayer[g].Uout = 0
                for l in 0..<k {
                    model.M2.Ylayer[g].Uout += model.M2.VLinks[l,g] * model.M2.Zlayer[l].Uout
                }
            }
        }
        
        //  9   (10-17)     Y1,Y2
        while (model.Y1J == nil || model.Y2G == nil) {
            model.Y1J = 0; model.Y2G = 0
            
            //  10          Y1,Y2
            for j in 0..<m {
                if model.M1.M11.Ylayer[model.Y1J!].Uout + model.M1.M12.Ylayer[model.Y1J!].Uout < model.M1.M11.Ylayer[j].Uout + model.M1.M12.Ylayer[j].Uout  {
                    model.Y1J = j
                }
                if model.M2.Ylayer[model.Y2G!].Uout < model.M2.Ylayer[j].Uout {
                    model.Y2G = j
                }
            }
            
            //  11          Yout    (12)
            for j in 0..<m {
                if j != model.Y1J! && model.M1.M11.Ylayer[j].Uout != -1 {
                    model.M1.M11.Ylayer[j].Uout = 0
                    model.M1.M12.Ylayer[j].Uout = 0
                }
                if j != model.Y2G! && model.M2.Ylayer[j].Uout != -1 { model.M2.Ylayer[j].Uout = 0 }
            }
            model.M1.M11.Ylayer[model.Y1J!].Uout = 1
            model.M1.M12.Ylayer[model.Y1J!].Uout = 1
            model.M2.Ylayer[model.Y2G!].Uout = 1
            
            //  13          p11,p12
            normP1r = 0.0; normP2r = 0.0
            for i in 0..<n {
                if model.ImaxM1 >= model.M1.Slayer[i].Uin {
                    normP1r += 1
                }
                if model.IminM1 <= model.M1.Slayer[i].Uin {
                    normP2r += 1
                }
            }
            model.M1.M11.p = normP1r / Double(n)
            model.M1.M12.p = normP2r / Double(n)
            
            normM2Zout = 0.0
            for z in model.M2.Zlayer {
                normM2Zout += z.Uout
            }
            
            //  14          CHECK p11,p12,p2
            if model.M1.M11.p < model.M1.p1 {
                model.M1.M11.Ylayer[model.Y1J!].Uout = -1
                model.Y1J = nil
                continue
            }
            if model.M1.M12.p < model.M1.p1 {
                model.M1.M12.Ylayer[model.Y1J!].Uout = -1
                model.Y1J = nil
                continue
            }
            if normM2Zout / normM2Sout < model.M2.p2 {
                model.M2.Ylayer[model.Y2G!].Uout = -1
                model.Y2G = nil
                continue
            }
            
            //  15          CHECK p1
            if model.M1.p1 > model.M1.M11.p + model.M1.M12.p - 1 {
                model.Y1J = nil     // excess ?
                model.Y2G = nil     // excess ?
                continue
            }
            
            //  16          Links   (17)
            for i in 0..<n {
                model.M1.M11.bLinks[i,model.Y1J!] = model.M1.M11.Zlayer[i].Uin
                model.M1.M11.tLinks[model.Y1J!,i] = model.M1.M11.Zlayer[i].Uin
                model.M1.M12.bLinks[i,model.Y1J!] = model.M1.M12.Zlayer[i].Uin
                model.M1.M12.tLinks[model.Y1J!,i] = model.M1.M12.Zlayer[i].Uin
            }
            for l in 0..<k {
                model.M2.VLinks[l,model.Y2G!] = (model.M2.L * model.M2.Zlayer[l].Uout) / (model.M2.L - 1.0 + normM2Zout)
                model.M2.WLinks[model.Y2G!,l] = model.M2.Zlayer[l].Uout
            }
        }
        
        //  21-22       LinksHQ     (18-20)
        for j in 0..<m {
            if j == model.Y1J! {
                for d in 0..<m {
                    if d == model.Y2G! {
                        model.Links.H1[model.Y1J!,model.Y2G!] = 1
                        model.Links.H2[model.Y2G!,model.Y1J!] = 1
                    }
                    else {
                        model.Links.H1[model.Y1J!,d] = 0
                        model.Links.H2[d,model.Y1J!] = 0
                    }
                }
            }
            if j == model.Y2G! {
                for d in 0..<m {
                    if d == model.Y1J! {
                        model.Links.Q1[model.Y2G!,model.Y1J!] = 1
                        model.Links.Q2[model.Y1J!,model.Y2G!] = 1
                    }
                    else {
                        model.Links.Q1[model.Y2G!,d] = 0
                        model.Links.Q2[d,model.Y2G!] = 0
                    }
                }
            }
        }
        
        model.M1.M11.Ylayer[model.Y1J!].Uout = -1
        model.M1.M12.Ylayer[model.Y1J!].Uout = -1
        model.M2.Ylayer[model.Y2G!].Uout = -1
        model.Y1J = nil; model.Y2G = nil;
    }
    //  23              FINISH
 }
