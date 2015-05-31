import Darwin

func machineDetermination (inout model : Model, signals: [Node]) -> [Node]
{
    model.M1.Slayer = signals
    var normP1r = 0.0; var normP2r = 0.0; var maxM1Sout = 0.0;
    
    //  1-2             INITIALIZATION
    let n = count(model.M1.Slayer)
    let k = count(model.M2.Slayer)
    let m = count(model.M2.Ylayer)
    
    //  4               Sout    (3)
    
    //  5               Zout    (6)
    maxM1Sout = model.M1.Slayer[0].Uout
    for s in model.M1.Slayer { if s.Uout > maxM1Sout {maxM1Sout = s.Uout} }
    for i in 0..<n {
        model.M1.M11.Zlayer[i].Uout = model.M1.Slayer[i].Uout / maxM1Sout
    }
    
    //  7               Yout
    for j in 0..<m {
            model.M1.M11.Ylayer[j].Uout = 0
            for i in 0..<n {
                model.M1.M11.Ylayer[j].Uout += model.M1.M11.bLinks[i,j] - model.M1.M11.Zlayer[i].Uout
            }
    }
    
    //  8   (9-19)      Y1J & Y2G
    
    //  9               Y1J
    model.Y1J = nil
    while model.Y1J == nil {
        model.Y1J = 0
        for j in 0..<m {
            if pow(model.M1.M11.Ylayer[model.Y1J!].Uout,2) > pow(model.M1.M11.Ylayer[j].Uout,2) {
                model.Y1J! = j
            }
        }
        
        //  12              p11     (10-11)
        normP1r = 0.0
        for i in 0..<n {
            if model.ImaxM1 >= model.M1.Slayer[i].Uin {
                normP1r += 1
            }
        }
        model.M1.M11.p = normP1r / Double(n)
        
        //  13              CHECK p11,p1
        if model.M1.M11.p < model.M1.p1 {
            model.Y1J = nil
            continue
        }
        
        //  17              p12     (14-16)
        normP2r = 0.0
        for i in 0..<n {
            if model.IminM1 <= model.M1.Slayer[i].Uin {
                normP2r += 1
            }
        }
        model.M1.M12.p = normP2r / Double(n)
        
        //  18              CHECK p12,p1
        if model.M1.M12.p < model.M1.p1 {
            model.Y1J = nil
            continue
        }
        
        //  19              CHECK p11,p12,p1
        if model.M1.p1 > model.M1.M11.p + model.M1.M12.p - 1{
            model.Y1J = nil
            continue
        }
    }
    
    //  21          Y2G     (20)
    for i in 0..<m {
        if model.Links.H1[model.Y1J!,i] == 1 {
            model.Y2G = i
        }
    }
    
    //  22          Sin     (23)
    for l in 0..<k {
        model.M2.Slayer[l].Uin = model.M2.WLinks[model.Y2G!,l]
    }
    
    //  24          FINISH
    return model.M2.Slayer
}