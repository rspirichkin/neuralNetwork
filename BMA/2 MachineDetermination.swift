func machineDetermination (inout model : Model, signals: [Node]) -> [Node]
{
    //return signals
    //                  INPUT SIGNALS to M1
    let n = count(model.M1.Slayer)
    let k = count(model.M2.Slayer)
    let m = count(model.M2.Zlayer)
    model.M1.Slayer = signals
    
    //model.M2.Slayer.removeAll(keepCapacity: true)
    
    //  1-2             INITIALIZATION
    
    //  3               TO M1
    
    //  4               Sout = in
    //for s in 0..<n {
   //     model.M1.Slayer[s].Uout = model.M1.Slayer[s].Uin
   // }
    
    //  5               Zin = Sin / max
    var maxM1Sout = model.M1.Slayer[0].Uout
    for s in model.M1.Slayer {
        if s.Uout > maxM1Sout {
            maxM1Sout = s.Uout
        }
    }
    //  !!!
    //  did BEFORE
    for i in 0..<n {
        model.M1.M11.Zlayer[i].Uin = model.M1.Slayer[i].Uout / maxM1Sout
    }
    
    //  6               M11     Zout = Zin
    for z in 0..<n {
        model.M1.M11.Zlayer[z].Uout = model.M1.M11.Zlayer[z].Uin
    }
    
    //  7               M11     Yout = Zout * b
    for j in 0..<m {
        if model.M1.M11.Ylayer[j].Uout != -1 {
            model.M1.M11.Ylayer[j].Uout = 0
            for i in 0..<n {
                model.M1.M11.Ylayer[j].Uout += model.M1.M11.bLinks[i,j] * model.M1.M11.Zlayer[i].Uout
            }
        }
    }
    
    //  8   (9-19)      Y1j is searching
    
    //  9               Y1j = max (Yj..)
    model.Y1j = nil
    while model.Y1j == nil {
        model.Y1j = 0
        for j in 0..<m {
            if model.M1.M11.Ylayer[model.Y1j!].Uout > model.M1.M11.Ylayer[j].Uout {
                model.Y1j! = j
            }
        }
        
        //  10              Y1j.out = 1
        for j in 0..<m {
            if j != model.Y1j! {
                model.M1.M11.Ylayer[j].Uout = 0
            }
        }
        model.M1.M11.Ylayer[model.Y1j!].Uout = 1
        
        //  11              Zout links to Y1j
        for i in 0..<n {
            model.M1.M11.Zlayer[i].Uout = model.M1.M11.Ylayer[model.Y1j!].Uout * model.M1.M11.tLinks[model.Y1j!, i]
        }
        
        //  12              p11
        
        //  NB
        //  NB
        //  NB
        
        var normP1r = 0.0
        for i in 0..<n {
            if model.ImaxM1 >= model.M1.Slayer[i].value {
                normP1r += 1
            }
        }
        model.M1.M11.p = normP1r / Double(n)
        //  NB
        
        //  13              CHECK p11,p1
        if model.M1.M11.p < model.M1.p1 {
            model.Y1j = nil
            continue
        }
        
        //  14              Y1j (M12) = Y1j (M11)
        //  ???
        
        //  15              Y1j.out = 1
        for j in 0..<m {
            if j != model.Y1j! {
                model.M1.M12.Ylayer[j].Uout = 0
            }
        }
        model.M1.M12.Ylayer[model.Y1j!].Uout = 1
        
        //  16              M12 Zout links to Y1j
        for i in 0..<n {
            model.M1.M12.Zlayer[i].Uout = model.M1.M12.Ylayer[model.Y1j!].Uout * model.M1.M12.tLinks[model.Y1j!, i]
        }
        
        //  17              p12
        //  NB
        //  NB
        //  NB
        
        var normP2r = 0.0
        for i in 0..<n {
            if model.IminM1 <= model.M1.Slayer[i].value {
                normP2r += 1
            }
        }
        model.M1.M12.p = normP2r / Double(n)
        //  NB
        
        //  18              CHECK p11,p1
        if model.M1.M12.p < model.M1.p1 {
            model.Y1j = nil
            continue
        }
        
        //  19              CHECK p11,p12,p1
        if model.M1.p1 > model.M1.M11.p + model.M1.M12.p - 1{
            model.Y1j = nil
            continue
        }
    }
    
    //  20          ACTIVIZATION of Xj
    //  ???
    
    //  21          ACTIVIZATION of Y2g
    model.Y3g = model.Y1j
    
    //  22          Zout = Wgl
    for l in 0..<k {
        model.M2.Zlayer[l].Uout = model.M2.WLinks[model.Y3g!,l]
    }
    
    //  23          Sout
    for l in 0..<k {
        model.M2.Slayer[l].Uin = model.M2.Zlayer[l].Uout
    }
    for l in 0..<k {
        model.M2.Slayer[l].Uout = model.M2.Slayer[l].Uin
    }
    
    //  24          FINISH
    
    return model.M2.Slayer
}