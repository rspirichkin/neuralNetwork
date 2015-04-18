func machineLearning (inout #model: Model, #signalsIn : [Node], #signalsOut : [Node])
{
    //                  ADDITION OF NEW PAIR
    model.appendPair(arrayM1 : signalsIn, arrayM2 : signalsIn)
    
    //  1-2             INITIALIZATION
    
    //  3   (4-22)
    
    //  4               OUT of S
    
    
    
    //  n, k, m, q - values for computer, NOT for human !!!
        var n = model.M1.Slayer.count - 1
        var k = model.M2.Slayer.count - 1
        var m = model.Player.count - 1
        var q = 1//model.count - 1
        
        //  3   (4-22)
        //for model in models {
            
            //  4
            for SNode in model.M1.Slayer {
                SNode.Uout = SNode.value
            }
            for SNode in model.M2.Slayer {
                SNode.Uout = SNode.value
            }
            //  4.2
    for z in model.M1.M11.Zlayer {
        z.Uin = model.ImaxM1!
    }
    for z in model.M1.M12.Zlayer {
        z.Uin = model.IminM1!
    }
            //var Imax, Imin : Double
            //  ?? Imax, Imin
            //Imax = 0
            //Imin = 0
            //  ??  Imax & Imin are supplied to Z.Uin
            
            //  5   (6-17)
            //  for each Imax & Imin  && model.M2.Slayer[l].Uout
            if (true) { // ?? for each ..
                //  6
                //  ??  max(M1.Slayer[i].Uout)  ?|?  min(M1.Slayer[i].Uout)
                var maxSUot = model.M1.Slayer[0].Uout
                var minSUot = model.M1.Slayer[0].Uout
                for SNode in model.M1.Slayer {
                    if SNode.Uout > maxSUot { maxSUot = SNode.Uout }
                    if SNode.Uout < minSUot { minSUot = SNode.Uout }
                }
                for i in 0...n {
                    model.M1.M11.Zlayer[i].Uin = model.M1.Slayer[i].Uout / maxSUot
                    model.M1.M12.Zlayer[i].Uin = model.M1.Slayer[i].Uout / minSUot
                }
                var normM2SUot = 0.0
                for i in 0...k {
                    normM2SUot += model.M2.Slayer[i].Uout
                    model.M2.Zlayer[i].Uin = model.M2.Slayer[i].Uout
                }
                
                //  7
                for ZNode in model.M1.M11.Zlayer {
                    ZNode.Uout = ZNode.value
                }
                for ZNode in model.M1.M12.Zlayer {
                    ZNode.Uout = ZNode.value
                }
                for ZNode in model.M2.Zlayer {
                    ZNode.Uout = ZNode.value
                }
                
                //  8
                for j in 0...m {
                    if model.M1.M11.Ylayer[j].Uout != -1 {
                        model.M1.M11.Ylayer[j].Uout = 0
                        if model.M1.M12.Ylayer[j].Uout != -1 {
                            model.M1.M12.Ylayer[j].Uout = 0
                            for i in 0...n {
                                model.M1.M11.Ylayer[j].Uout += model.M1.M11.bLinks[i,j] * model.M1.M11.Zlayer[i].Uout
                                model.M1.M12.Ylayer[j].Uout += model.M1.M12.bLinks[i,j] * model.M1.M12.Zlayer[i].Uout
                            }
                        }
                        else {
                            for i in 0...n {
                                model.M1.M11.Ylayer[j].Uout += model.M1.M11.bLinks[i,j] * model.M1.M11.Zlayer[i].Uout
                            }
                        }
                    }
                    else if model.M1.M12.Ylayer[j].Uout != -1 {
                        model.M1.M12.Ylayer[j].Uout = 0
                        for i in 0...n {
                            model.M1.M12.Ylayer[j].Uout += model.M1.M12.bLinks[i,j] * model.M1.M12.Zlayer[i].Uout
                        }
                    }
                }
                for g in 0...m {
                    if model.M2.Ylayer[g].Uout != -1 {
                        model.M2.Ylayer[g].Uout = 0
                        for l in 0...k {
                            model.M2.Ylayer[g].Uout += model.M2.VLinks[l,g] * model.M2.Zlayer[l].Uout
                        }
                    }
                }
                
                //  9   (10-17)
                while (model.Y1j == nil || model.Y1j == nil || model.Y2g == nil) {
                    model.Y1j = 0; model.Y1j = 0; model.Y2g = 0
                    
                    //  10
                    for j in 0...m {
                        if model.M1.M11.Ylayer[j].Uout > model.M1.M11.Ylayer[model.Y1j!].Uout {
                            model.Y1j = j
                        }
                        if model.M1.M12.Ylayer[j].Uout > model.M1.M12.Ylayer[model.Y1j!].Uout {
                            model.Y1j = j
                        }
                        if model.M2.Ylayer[j].Uout > model.M2.Ylayer[model.Y2g!].Uout {
                            model.Y2g = j
                        }
                    }
                    
                    //  11
                    for j in 0...m {
                        if j != model.Y1j  {
                            model.M1.M11.Ylayer[j].Uout = 0
                        } else {
                            model.M1.M11.Ylayer[j].Uout = 1
                        }
                        if j != model.Y1j  {
                            model.M1.M12.Ylayer[j].Uout = 0
                        } else {
                            model.M1.M12.Ylayer[j].Uout = 1
                        }
                        if j != model.Y2g  {
                            model.M2.Ylayer[j].Uout = 0
                        } else {
                            model.M2.Ylayer[j].Uout = 1
                        }
                    }
                    
                    //  12
                    for i in 0...n {
                        model.M1.M11.Zlayer[i].Uout = model.M1.M11.Ylayer[model.Y1j!].Uout * model.M1.M11.tLinks[model.Y1j!,i]
                        model.M1.M12.Zlayer[i].Uout = model.M1.M12.Ylayer[model.Y1j!].Uout * model.M1.M11.tLinks[model.Y1j!,i]
                    }
                    for l in 0...k {
                        model.M2.Zlayer[l].Uout = model.M2.Ylayer[model.Y2g!].Uout * model.M2.WLinks[model.Y2g!,l]
                    }
                    
                    //  13
                    //  ?? P1r*(f,ti)
                    model.M1.p11 = 1; model.M1.p12 = 1  // ??
                    //  13.2
                    var normM2Zout = 0.0
                    for ZNode in model.M2.Zlayer {
                        normM2SUot += ZNode.Uout
                    }
                    
                    //  14
                    if model.M1.p11 < model.M1.p1 {
                        model.M1.M11.Ylayer[model.Y1j!].Uout = -1
                        model.Y1j = nil
                        continue
                    }
                    if model.M1.p12 < model.M1.p1 {
                        model.M1.M12.Ylayer[model.Y1j!].Uout = -1
                        model.Y1j = nil
                        continue
                    }
                    if normM2Zout / normM2SUot < model.p2 {
                        model.M2.Ylayer[model.Y2g!].Uout = -1
                        model.Y2g = nil
                        continue
                    }
                    
                    //  15
                    if model.M1.p1 < model.M1.p11 + model.M1.p12 - 1 {
                        model.Y1j = nil     // excess ?
                        model.Y1j = nil     // excess ?
                        model.Y2g = nil     // excess ?
                        continue
                    }
                    
                    //  16
                    for i in 0...n {
                        model.M1.M11.bLinks[i,model.Y1j!] = model.M1.M11.Zlayer[i].Uin
                        model.M1.M11.tLinks[model.Y1j!,i] = model.M1.M11.Zlayer[i].Uin
                        model.M1.M12.bLinks[i,model.Y1j!] = model.M1.M12.Zlayer[i].Uin
                        model.M1.M12.tLinks[model.Y1j!,i] = model.M1.M12.Zlayer[i].Uin
                    }
                    for l in 0...k {
                        model.M2.VLinks[l,model.Y2g!] = (model.L * model.M2.Zlayer[l].Uout) / (model.L - 1.0 + normM2Zout)
                        model.M2.WLinks[model.Y2g!,l] = model.M2.Zlayer[l].Uout
                    }
                    
                    //  17
                    //  model.Y1j & model.Y1j activate X1J
                }
            }
            //  18
            // check the condition of 'graduation' M1 & M2
            
            //  19  (20-22)
            //  for every pair of Slayers
            //  ??? stil for every  (4-22)
            
            //  20
            //  X1J & model.Y2g
            //  ??
            
            //  21
            for d in 0...m {
                if d == model.Y1j! {
                    model.H1Links[model.Y1j!,model.Y1j!] = 1
                }
                else { model.H1Links[model.Y1j!,d] = 0 }
            }
            for j in 0...m {
                if j == model.Y1j! {
                    model.H2Links[model.Y1j!,model.Y1j!] = 1
                }
                else { model.H2Links[j,model.Y1j!] = 0 }
            }
            // may be integrate?
            
            //  22
            for d in 0...m {
                if d == model.Y2g! {
                    model.Q1Links[model.Y2g!,model.Y2g!] = 1
                }
                else { model.Q1Links[model.Y2g!,d] = 0 }
            }
            for j in 0...m {
                if j == model.Y2g {
                    model.Q2Links[model.Y2g!,model.Y2g!] = 1
                }
                else { model.Q2Links[j,model.Y2g!] = 0 }
            }
            
       // }
    //}
    
    //  23
    //  FINISH
}
