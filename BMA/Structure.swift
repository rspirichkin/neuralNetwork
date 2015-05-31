//
//  Algoritm1.swift
//  BMA015
//
//  Created by Roman Spirichkin on Feb/11/15.
//  Copyright (c) 2015 RomanSpirichkinOrganization. All rights reserved.
//

import Foundation

struct Node {
    var Uin, Uout : Double
    init(Uin: Double = 0, Uout: Double = 0) {
        self.Uin = Uin
        self.Uout = Uout
    }
}

class Pair {
    var arrayS1, arrayS2 : [Node]
    var pairImaxM1, pairIminM1 : Double?
    init(arrayS1 : [Node], arrayS2 : [Node]) {
        self.arrayS1 = arrayS1
        self.arrayS2 = arrayS2
        self.Imaxmin()
    }
    private func Imaxmin() {
        pairImaxM1 = self.arrayS1[0].Uin
        pairIminM1 = self.arrayS1[0].Uin
        for a in arrayS1 {
            if pairImaxM1 < a.Uin { pairImaxM1 = a.Uin }
            if pairIminM1 > a.Uin { pairIminM1 = a.Uin }
        }
    }
}

struct Module10 {
    var p : Double
    var Zlayer, Ylayer : [Node]
    var bLinks, tLinks : Matrix
    init (n: Int, m: Int) {
        p = 0.5
        Zlayer = [Node](count: n, repeatedValue: Node())
        Ylayer = [Node](count: m, repeatedValue: Node())
        bLinks = Matrix(rows: n, columns: m)
        tLinks = Matrix(rows: m, columns: n)
    }
}

struct Module1 {
    var p1 : Double
    var M11, M12 : Module10
    var Slayer, Xlayer : [Node]
    init (n: Int, m: Int) {
        p1 = 0.5    // p1
        M11 = Module10(n: n, m: m)
        M12 = Module10(n: n, m: m)
        Xlayer = [Node](count: m, repeatedValue: Node())
        Slayer = [Node](count: n, repeatedValue: Node())
    }
}

struct Module2 {
    var p2 : Double
    var Ylayer, Zlayer, Slayer : [Node]
    var VLinks, WLinks : Matrix
    internal var L : Double
    init (k: Int, m: Int) {
        p2 = -0.5    // p2
        Ylayer = [Node](count: m, repeatedValue: Node())
        Zlayer = [Node](count: k, repeatedValue: Node())
        Slayer = [Node](count: k, repeatedValue: Node())
        VLinks = Matrix(rows: k, columns: m)
        for Vl in 0...k - 1 {
            for Vg in 0...m - 1 {
                VLinks[Vl, Vg] = 1 / (1 + Double(k))
            }
        }
        WLinks = Matrix(rows: m, columns: k)
        L = 2.0
    }
}

class LinksHQ {
    var H1, H2, Q1, Q2 : Matrix
    init (m: Int) {
        H1 = Matrix(rows: m, columns: m)
        H2 = Matrix(rows: m, columns: m)
        Q1 = Matrix(rows: m, columns: m)
        Q2 = Matrix(rows: m, columns: m)
    }
}
class Model {
    var M1 : Module1
    var M2 : Module2
    var Links : LinksHQ
    var Y1J, Y2G : Int?     // Winning neurons
    var ImaxM1, IminM1 : Double?
    var pairs : [Pair]
    init (n: Int, k: Int, m: Int) {
        M1 = Module1(n: n, m: m)
        M2 = Module2(k: k, m: m)
        Links = LinksHQ(m: m)
        pairs = [Pair]()
    }
    func addPair(newPair : Pair) {
        // NB not let ?
        if let Imax = ImaxM1 {
            if ImaxM1! < newPair.pairImaxM1 { ImaxM1! = newPair.pairImaxM1! }
            if IminM1! > newPair.pairIminM1 { IminM1! = newPair.pairIminM1! }
        }
        else {
            ImaxM1 = newPair.pairImaxM1
            IminM1 = newPair.pairIminM1
        }
        self.pairs.append(newPair)
    }
}

