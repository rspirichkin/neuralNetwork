 func machineLearning (inout #model: Model, #pairs : [Pair])
{
    // SEARCH ImaxImin for Model
    model.ImaxM1 = pairs[0].pairImaxM1
    model.IminM1 = pairs[0].pairIminM1
    for pair in pairs {
        if model.ImaxM1 < pair.pairImaxM1 {
            model.ImaxM1 < pair.pairImaxM1
        }
    }
    
    for r in 0..<pairs.count {

        model.appendPair(pairs[r])  //  ADDITION OF NEW PAIR
        let n = count(model.M1.Slayer)
        let k = count(model.M2.Slayer)
        let m = count(model.Player)
        
        //  1-2             INITIALIZATION
        
        //  3   (4-22)
        
        //  4               Sout.   Imax/Imin
        //                  (Sout = Sin) & (Imax/Imin) in ADDITION OF NEW PAIR
        //                  (Imax/Imin)
        //  NB
        //  here    S1 := pairS1        S2 := pairS2
        model.M1.Slayer = pairs[r].arrayS1
        model.M2.Slayer = pairs[r].arrayS2
        //  NB
        
        //  5   (6-17)      FOR EACH (Imax/Imin) & Sout
        
        //  6               Zin.    Zi = Si/Smax
        //                          Zl = Sl
        var normM2Sout = 0.0
        var maxM1Sout = model.M1.Slayer[0].Uout
        var minM1Sout = model.M1.Slayer[0].Uout
        for s in model.M1.Slayer {
            if maxM1Sout < s.Uout { maxM1Sout = s.Uout }
            if minM1Sout > s.Uout { minM1Sout = s.Uout }
        }
        for i in 0..<n {
            model.M1.M11.Zlayer[i].Uin = model.M1.Slayer[i].Uout / maxM1Sout
            model.M1.M12.Zlayer[i].Uin = model.M1.Slayer[i].Uout / minM1Sout
        }
        for l in 0..<k {
            normM2Sout += model.M2.Slayer[l].Uout
            model.M2.Zlayer[l].Uin = model.M2.Slayer[l].Uout
        }
        
        //  7               Zout.
        for z in 0..<n {
            model.M1.M11.Zlayer[z].Uout = model.M1.M11.Zlayer[z].Uin
        }
        for z in 0..<n {
            model.M1.M12.Zlayer[z].Uout = model.M1.M12.Zlayer[z].Uin
        }
        for z in 0..<n {
            model.M2.Zlayer[z].Uout = model.M2.Zlayer[z].Uin
        }
        
        //  8               FOR EACH Y != -1
        //                              Y := ∑ b*Z
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
        
        //  9   (10-17)     SEARCH Y1,Y3
        while (model.Y1j == nil || model.Y1j == nil || model.Y3g == nil) {
            model.Y1j = 0; model.Y1j = 0; model.Y3g = 0
            
            //  10          SEARCH  Y1,Y3  by MAX Uout
            for j in 0..<m {
                if model.M1.M11.Ylayer[j].Uout > model.M1.M11.Ylayer[model.Y1j!].Uout {
                    model.Y1j = j
                }
                /*
                if model.M1.M12.Ylayer[j].Uout > model.M1.M12.Ylayer[model.Y1j!].Uout {
                    model.Y1j = j
                }
*/
                if model.M2.Ylayer[j].Uout > model.M2.Ylayer[model.Y3g!].Uout {
                    model.Y3g = j
                }
            }
            
            //  11          ACTIVATE Y1,Y3      (Y := 0 or 1)
            for j2 in 0..<m {
                
                if j2 != model.Y1j!  {
                    model.M1.M11.Ylayer[j2].Uout = 0
                } else {
                    model.M1.M11.Ylayer[j2].Uout = 1
                }
                
                if j2 != model.Y1j!  {
                    model.M1.M12.Ylayer[j2].Uout = 0
                } else {
                    model.M1.M12.Ylayer[j2].Uout = 1
                }

                if j2 != model.Y3g!  {
                    model.M2.Ylayer[j2].Uout = 0
                } else {
                    model.M2.Ylayer[j2].Uout = 1
                }

            }
            
            //  12          TRANSMISSION Y to Z           Zi := Y1j       Zl := Y3g
            for i in 0..<n {
                model.M1.M11.Zlayer[i].Uout = model.M1.M11.Ylayer[model.Y1j!].Uout * model.M1.M11.tLinks[model.Y1j!,i]
                model.M1.M12.Zlayer[i].Uout = model.M1.M12.Ylayer[model.Y1j!].Uout * model.M1.M11.tLinks[model.Y1j!,i]
            }
            for l in 0..<k {
                model.M2.Zlayer[l].Uout = model.M2.Ylayer[model.Y3g!].Uout * model.M2.WLinks[model.Y3g!,l]
            }
            
            //  13          p11 p12
            
                        //  NB
                        //  NB
                        //  NB
            
            var normP1r = 0.0
            for i in 0..<n {
                if model.ImaxM1 >= model.M1.Slayer[i].value {
                    normP1r += 1
                }
            }
            var normP2r = 0.0
            for i in 0..<n {
                if model.IminM1 <= model.M1.Slayer[i].value {
                    normP2r += 1
                }
            }
            model.M1.M11.p = normP1r / Double(n)
            model.M1.M12.p = normP2r / Double(n)
            
            var normM2Zout = 0.0
            for z in model.M2.Zlayer {
                normM2Zout += z.Uout
            }
            
            //  14          CHECK p11,p12,p2
            if model.M1.M11.p < model.M1.p1 {
                model.M1.M11.Ylayer[model.Y1j!].Uout = -1
                model.Y1j = nil
                continue
            }
            if model.M1.M12.p < model.M1.p1 {
                model.M1.M12.Ylayer[model.Y1j!].Uout = -1
                model.Y1j = nil
                continue
            }
            if normM2Zout / normM2Sout < model.M2.p2 {
                model.M2.Ylayer[model.Y3g!].Uout = -1
                model.Y3g = nil
                continue
            }
            
            //  15          CHECK p1
            if model.M1.p1 < model.M1.M11.p + model.M1.M12.p - 1 {
                model.Y1j = nil     // excess ?
                model.Y1j = nil     // excess ?
                model.Y3g = nil     // excess ?
                continue
            }
            
            //  16          ADAPTATION of Links
            for i in 0..<n {
                model.M1.M11.bLinks[i,model.Y1j!] = model.M1.M11.Zlayer[i].Uin
                model.M1.M11.tLinks[model.Y1j!,i] = model.M1.M11.Zlayer[i].Uin
                model.M1.M12.bLinks[i,model.Y1j!] = model.M1.M12.Zlayer[i].Uin
                model.M1.M12.tLinks[model.Y1j!,i] = model.M1.M12.Zlayer[i].Uin
            }
            for l in 0..<k {
                model.M2.VLinks[l,model.Y3g!] = (model.M2.L * model.M2.Zlayer[l].Uout) / (model.M2.L - 1.0 + normM2Zout)
                model.M2.WLinks[model.Y3g!,l] = model.M2.Zlayer[l].Uout
            }
            
            //  17          ACTIVIZATION of Xj
            //  ???
        }
        //  18          CHECK 'graduation' of M1 & M2
        
        //  19  (20-22) EVERY PAIR
        
        //  20          DETERMINATION Xj
        
        //  21&22       DETERMINATION Links M1-P-M2
        for j in 0..<m {
            if j == model.Y1j! {
                model.H1Links[model.Y1j!,model.Y1j!] = 1
            }
            else { model.H1Links[model.Y1j!,j] = 0 }
        }
        for j in 0..<m {
            if j == model.Y1j! {
                model.H2Links[model.Y1j!,model.Y1j!] = 1
            }
            else { model.H2Links[j,model.Y1j!] = 0 }
        }
        for d in 0..<m {
            if d == model.Y3g! {
                model.Q1Links[model.Y3g!,model.Y3g!] = 1
            }
            else { model.Q1Links[model.Y3g!,d] = 0 }
        }
        for j in 0..<m {
            if j == model.Y3g {
                model.Q2Links[model.Y3g!,model.Y3g!] = 1
            }
            else { model.Q2Links[j,model.Y3g!] = 0 }
        }
        
    }
    //  23              FINISH
    var finish = true
}
