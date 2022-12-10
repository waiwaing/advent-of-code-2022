import Foundation

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)

struct Point: Hashable { let x: Int; let y: Int; }
var tailVisitedLocations = Set<Point>()

var head = Point(x: 0, y: 0)
var tail = Point(x: 0, y: 0)

input.split(separator: "\n").flatMap { 
    let parts = $0.split(separator: " ")
    return [String](repeating: String(parts[0]), count: Int(parts[1])!)
}.forEach { instruction in
    tailVisitedLocations.insert(tail)

    switch(instruction) {
        case "U": head = Point(x: head.x, y: head.y + 1)
        case "D": head = Point(x: head.x, y: head.y - 1)
        case "L": head = Point(x: head.x - 1, y: head.y)
        case "R": head = Point(x: head.x + 1, y: head.y)
        default: fatalError()
    }

    switch (head.x - tail.x, head.y - tail.y) {
        case (+2, +0): tail = Point(x: tail.x + 1, y: tail.y + 0)
        case (+0, +2): tail = Point(x: tail.x + 0, y: tail.y + 1)
        case (-2, +0): tail = Point(x: tail.x - 1, y: tail.y + 0)
        case (+0, -2): tail = Point(x: tail.x + 0, y: tail.y - 1)
        case (+1, +2): tail = Point(x: tail.x + 1, y: tail.y + 1)
        case (+2, +1): tail = Point(x: tail.x + 1, y: tail.y + 1)
        case (+1, -2): tail = Point(x: tail.x + 1, y: tail.y - 1)
        case (+2, -1): tail = Point(x: tail.x + 1, y: tail.y - 1)
        case (-1, +2): tail = Point(x: tail.x - 1, y: tail.y + 1)
        case (-2, +1): tail = Point(x: tail.x - 1, y: tail.y + 1)
        case (-1, -2): tail = Point(x: tail.x - 1, y: tail.y - 1)
        case (-2, -1): tail = Point(x: tail.x - 1, y: tail.y - 1)
        case (-1...1, -1...1): break
        default: print(head.x, tail.x)
    }
}

tailVisitedLocations.insert(tail)
print(tailVisitedLocations.count)
