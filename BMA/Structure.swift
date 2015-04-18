//
//  Algoritm1.swift
//  BMA015
//
//  Created by Roman Spirichkin on Dec/11/14.
//  Copyright (c) 2015 RomanSpirichkinOrganization. All rights reserved.
//

import Foundation

class Matrix {
    let rows, columns : Int
    var grid : [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows * columns, repeatedValue: 1.0)
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            return grid[(row * columns) + column]
        }
        set {
            grid[(row * columns) + column] = newValue
        }
    }
}

class Node {
    var value, Uin, Uout : Double
    init(value: Double = 0, Uin: Double = 0, Uout: Double = 0) {
        self.value = value
        self.Uin = Uin
        self.Uout = Uout
    }
}

class Pair {
    var arrayM1, arrayM2 : [Node]
    var pairImaxM1, pairIminM1 : Double
    init(arrayM1 : [Node], arrayM2 : [Node]) {
        self.arrayM1 = arrayM1
        self.arrayM2 = arrayM2
        pairImaxM1 = arrayM1[0].value
        pairIminM1 = arrayM1[0].value
        for a in arrayM1 {
            if pairImaxM1 < a.value { pairImaxM1 = a.value }
            if pairIminM1 > a.value { pairIminM1 = a.value }
        }
    }
}

class Module10 {
    var Zlayer, Ylayer : [Node]
    var bLinks, tLinks : Matrix
    var R : Int
    init (n: Int, m: Int) {
        Zlayer = [Node](count: n, repeatedValue: Node())
        Ylayer = [Node](count: m, repeatedValue: Node())
        self.R = 0
        bLinks = Matrix(rows: m, columns: n)
        tLinks = Matrix(rows: m, columns: n)
    }
}

class Module1 {
    var M11, M12 : Module10
    var Slayer, Xlayer : [Node]
    var p1, p11, p12 : Double
    var R : Int
    init (n: Int, m: Int) {
        M11 = Module10(n: n, m: m)
        M12 = Module10(n: n, m: m)
        Xlayer = [Node](count: m, repeatedValue: Node())
        Slayer = [Node](count: n, repeatedValue: Node())
        p1 = 1.0; p11 = 0.5; p12 = 0.5  // p1 - ?
        R = 0
    }
}

class Module2 {
    var Ylayer, Zlayer, Slayer : [Node]
    var VLinks, WLinks : Matrix
    var R, G1, G2 : Int
    init (k: Int, m: Int) {
        Ylayer = [Node](count: m, repeatedValue: Node())
        Zlayer = [Node](count: k, repeatedValue: Node())
        Slayer = [Node](count: k, repeatedValue: Node())
        VLinks = Matrix(rows: k, columns: m)
        for Vl in 0...k - 1 {
            for Vg in 0...m - 1 {
                VLinks[Vl, Vg] = 1 / (1 + Double(k))
            }
        }
        WLinks = Matrix(rows: k, columns: m)
        R = 0; G1 = 0; G2 = 0
    }
}

class Model {
    var M1 : Module1
    var M2 : Module2
    var pairs : [Pair]
    var ImaxM1, IminM1 : Double?
    var Player : [Node]
    var H1Links, H2Links, Q1Links, Q2Links : Matrix
    var Y1j, Y2g : Int?     // Winning neurons
    var G : Int
    var L : Double
    var p2 : Double
    var P1ft, P2ft : Int
    init (n: Int, k: Int, m: Int) {
        M1 = Module1(n: n, m: m)
        M2 = Module2(k: k, m: m)
        pairs = [Pair]()
        Player = [Node](count: m, repeatedValue: Node())
        H1Links = Matrix(rows: m, columns: m)
        H2Links = Matrix(rows: m, columns: m)
        Q1Links = Matrix(rows: m, columns: m)
        Q2Links = Matrix(rows: m, columns: m)
        self.G = 0
        self.L = 2.0
        p2 = 0.0    // p2 - ?
        P1ft = 0
        P2ft = 0
    }
    func appendPair(#arrayM1 : [Node], arrayM2 : [Node]) {
        var newPair = Pair(arrayM1: arrayM1, arrayM2: arrayM2)
        // NB not let ?
        if let Imax = ImaxM1 {
            if ImaxM1! < newPair.pairImaxM1 { ImaxM1! = newPair.pairImaxM1 }
            if IminM1! < newPair.pairIminM1 { IminM1! = newPair.pairIminM1 }
        }
        else {
            ImaxM1 = newPair.pairImaxM1
            IminM1 = newPair.pairIminM1
        }
        self.pairs.append(newPair)
        self.M1.Slayer = arrayM1
    }
}
