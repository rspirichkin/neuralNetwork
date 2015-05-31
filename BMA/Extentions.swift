
import UIKit
import Foundation


extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}


class Matrix {
    let rows, columns : Int
    var grid = [[Double]]()
    var wasSeted = false
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        for _ in 1...rows {
            grid.append(Array(count: columns, repeatedValue: 0.0))
        }
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            return grid[row][column]
        }
        set {
            grid[row][column] = newValue
        }
    }
}


var n = 2; var k = 1; var h = 1;
var model = Model(n: n*h, k: k*h, m: (n+k)*h)
var pairs = [Pair]()

let WhiteCG = UIColor.whiteColor().CGColor
let SeaFoam = UIColor(red: 0, green: 1, blue: 0.5, alpha: 1)
let Aqua = UIColor(red: 0, green: 0.5, blue: 1.0, alpha: 0.75)
let SeaFoamCG = SeaFoam.CGColor; let AquaCG = Aqua.CGColor
let Gray = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1); let GrayCG = Gray.CGColor
