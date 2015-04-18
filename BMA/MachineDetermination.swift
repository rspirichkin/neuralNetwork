func machineDetermination (signals: [Double], k_ : Int, models : [Model]) -> [Double]
{
    //  1-2
    var model = Model(n: signals.count, k: k_, m: 2*signals.count)
    //  n, k, m - values for computer, NOT for human !!!
    var n = signals.count - 1
    var m = 2 * n + 1
    var k = k_ - 1
    
    //  3   Input image to M1
    
    //  4
    for SNode in model.M1.Slayer {
        SNode.Uout = SNode.value
    }
    
    //  5
    var maxSUot = model.M1.Slayer[0].Uout
    for SNode in model.M1.Slayer {
        if SNode.Uout > maxSUot {
            maxSUot = SNode.Uout
        }
    }
    for i in 0...n {
        model.M1.M11.Zlayer[i].Uin = model.M1.Slayer[i].Uout / maxSUot
    }
    
    //  6
    for ZNode in model.M1.M11.Zlayer {
        ZNode.Uout = ZNode.Uin
    }
    
    //  7
    
    
    // beta
    var signalsDeterminated = [Double](count: 3, repeatedValue: signals[0])
    return signalsDeterminated
}