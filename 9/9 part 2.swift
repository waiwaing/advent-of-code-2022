import Foundation

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)

struct Point: Hashable { let x: Int; let y: Int; }
var tailVisitedLocations = Set<Point>()
var knots = [Point](repeating: Point(x: 0, y: 0), count: 10)
tailVisitedLocations.insert(knots[9])

func newKnotLocation(head: Point, tail: Point) -> Point {
    switch (head.x - tail.x, head.y - tail.y) {
        case (-1...1, -1...1): return tail
        case (+2, +0): return Point(x: tail.x + 1, y: tail.y + 0)
        case (+0, +2): return Point(x: tail.x + 0, y: tail.y + 1)
        case (-2, +0): return Point(x: tail.x - 1, y: tail.y + 0)
        case (+0, -2): return Point(x: tail.x + 0, y: tail.y - 1)
        case (+1 ... +2, +1 ... +2): return Point(x: tail.x + 1, y: tail.y + 1)
        case (+1 ... +2, -2 ... -1): return Point(x: tail.x + 1, y: tail.y - 1)
        case (-2 ... -1, +1 ... +2): return Point(x: tail.x - 1, y: tail.y + 1)
        case (-2 ... -1, -2 ... -1): return Point(x: tail.x - 1, y: tail.y - 1)
        default: fatalError() 
    }
}

input.split(separator: "\n").flatMap { line in 
    [Character](repeating: line[line.startIndex], count: Int(line.split(separator: " ")[1])!)
}.forEach { instruction in
    switch(instruction) {
        case "U": knots[0] = Point(x: knots[0].x, y: knots[0].y + 1)
        case "D": knots[0] = Point(x: knots[0].x, y: knots[0].y - 1)
        case "L": knots[0] = Point(x: knots[0].x - 1, y: knots[0].y)
        case "R": knots[0] = Point(x: knots[0].x + 1, y: knots[0].y)
        default: fatalError()
    }

    (1...9).forEach { i in knots[i] = newKnotLocation(head: knots[i - 1], tail: knots[i])} 
    tailVisitedLocations.insert(knots[9])
}

print(tailVisitedLocations.count)
