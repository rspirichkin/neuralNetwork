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

struct Node {
    var value, Uin: Double
    var Uout : Double
    init(value: Double = 0, Uin: Double = 0, Uout: Double = 0) {
        self.value = value
        self.Uin = Uin
        self.Uout = Uout
    }
    mutating func setUout (newUout : Double) {
       self.Uout = newUout
    }
    mutating func setUin (newUin : Double) {
        self.Uout = newUin
    }
}

class Pair {
    var arrayS1, arrayS2 : [Node]
    var pairImaxM1, pairIminM1 : Double?
    init(arrayS1 : [Node], arrayS2 : [Node]) {
        self.arrayS1 = arrayS1
        self.arrayS2 = arrayS2
        self.Imaxmin()
        normalization()
        self.Imaxmin()
    }
    private func Imaxmin() {
        pairImaxM1 = self.arrayS1[0].value
        pairIminM1 = arrayS1[0].value
        for a in arrayS1 {
            if pairImaxM1 < a.value { pairImaxM1 = a.value }
            if pairIminM1 > a.value { pairIminM1 = a.value }
        }
    }
    private func normalization() {
        for i in 0..<self.arrayS1.count {
            self.arrayS1[i].value /= self.pairImaxM1!
            self.arrayS1[i].Uout /= self.pairImaxM1!
        }
    }
}




struct Module10 {
    var Zlayer, Ylayer : [Node]
    var bLinks, tLinks : Matrix
    var p : Double
    init (n: Int, m: Int) {
        Zlayer = [Node](count: n, repeatedValue: Node())
        Ylayer = [Node](count: m, repeatedValue: Node())
        bLinks = Matrix(rows: m, columns: n)
        tLinks = Matrix(rows: m, columns: n)
        p = 0.5
    }
    mutating func assign (i : Int, value : Double) {
        Zlayer[i].setUout(value)// (value)
    }
}

struct Module1 {
    var M11, M12 : Module10
    var Slayer, Xlayer : [Node]
    var p1 : Double
    init (n: Int, m: Int) {
        M11 = Module10(n: n, m: m)
        M12 = Module10(n: n, m: m)
        Xlayer = [Node](count: m, repeatedValue: Node())
        Slayer = [Node](count: n, repeatedValue: Node())
        p1 = 1.0    // p1 - ?
    }
}

struct Module2 {
    var Ylayer, Zlayer, Slayer : [Node]
    var VLinks, WLinks : Matrix
    var p2 : Double
    var L : Double
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
        p2 = 0.0    // p2 - ?
        L = 2.0
    }
}

class Model {
    var M1 : Module1
    var M2 : Module2
    var Player : [Node]
    var H1Links, H2Links, Q1Links, Q2Links : Matrix
    var Y1j, Y3g : Int?     // Winning neurons
    var pairs : [Pair]
    var ImaxM1, IminM1 : Double?
    var P1ft, P2ft : Int
    init (n: Int, k: Int, m: Int) {
        M1 = Module1(n: n, m: m)
        M2 = Module2(k: k, m: m)
        Player = [Node](count: m, repeatedValue: Node())
        H1Links = Matrix(rows: m, columns: m)
        H2Links = Matrix(rows: m, columns: m)
        Q1Links = Matrix(rows: m, columns: m)
        Q2Links = Matrix(rows: m, columns: m)
        pairs = [Pair]()
        P1ft = 0
        P2ft = 0
    }
    func appendPair(newPair : Pair) {
        
        var point = Point(x: 0.0, y: 0.0)
        point.moveToTheRightBy(200.0)
        var points : [Point] = []
        points.append(Point(x: 10.0, y: 10.0) )
        points[0].moveToTheRightBy(20.0)
        
        
        
        newPair.Imaxmin()
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
        self.M1.Slayer = newPair.arrayS1
    }
}


struct Point {
    var x, y: Double
    
    mutating func moveToTheRightBy(dx: Double) {
        x += dx
    }
}

