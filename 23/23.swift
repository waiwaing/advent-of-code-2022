import Foundation

struct Point : Hashable {let x: Int; let y: Int}
var space: Set<Point> = Set()

let input: String = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
input.split(separator: "\n").enumerated().forEach { (i, line) in
    line.enumerated().forEach { (j, char) in
        if(char == "#") {
            space.insert(Point(x: j, y: i))
        }
    }
}

func pointFor(elf: Point, directions: [Character]) -> Point {
    let adjacents = Set([(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, 1), (1, 0), (1, -1)]
        .map { (x, y) in Point(x: elf.x + x, y: elf.y + y)})

    if space.intersection(adjacents).count == 0 {
        return elf
    }

    let direction = directions.first(where: { direction in switch(direction) {
            case "N": return 
                !space.contains(Point(x: elf.x + 0, y: elf.y - 1)) && 
                !space.contains(Point(x: elf.x + 1, y: elf.y - 1)) &&
                !space.contains(Point(x: elf.x - 1, y: elf.y - 1))
            case "E": return 
                !space.contains(Point(x: elf.x + 1, y: elf.y - 1)) && 
                !space.contains(Point(x: elf.x + 1, y: elf.y + 0)) &&
                !space.contains(Point(x: elf.x + 1, y: elf.y + 1))
            case "S": return 
                !space.contains(Point(x: elf.x + 0, y: elf.y + 1)) && 
                !space.contains(Point(x: elf.x + 1, y: elf.y + 1)) &&
                !space.contains(Point(x: elf.x - 1, y: elf.y + 1))
            case "W": return 
                !space.contains(Point(x: elf.x - 1, y: elf.y - 1)) && 
                !space.contains(Point(x: elf.x - 1, y: elf.y + 0)) &&
                !space.contains(Point(x: elf.x - 1, y: elf.y + 1))
            default: fatalError()
        }})

    switch(direction) {
        case "N": return Point(x: elf.x, y: elf.y - 1)
        case "E": return Point(x: elf.x + 1, y: elf.y)
        case "S": return Point(x: elf.x, y: elf.y + 1)
        case "W": return Point(x: elf.x - 1, y: elf.y)
        default: return elf
    }
}

var directions: [Character] = ["N", "S", "W", "E"]
func round() {
    let proposedPoints = space.map { pointFor(elf: $0, directions: directions) }
    space = Set(space.map { elf -> Point in
        let proposedPoint = pointFor(elf: elf, directions: directions)
        return proposedPoints.filter({ $0 == proposedPoint }).count > 1 ? elf : proposedPoint
    })

    directions.append(directions.removeFirst())
}

(0..<10).forEach {  _ in round() }

// Part 1
let xs = (space.map { $0.x }.min()!) ... (space.map { $0.x }.max()!)
let ys = (space.map { $0.y }.min()!) ... (space.map { $0.y }.max()!)

print(xs.flatMap { x in ys.map { y in Point(x: x, y: y)}}.filter { !space.contains($0) }.count)

// Part 2
var roundsToDate = 10
var prevState = space
while(true) {
    round()
    roundsToDate += 1
    if (prevState == space) {
        break
    } 

    prevState = space
}

print(roundsToDate)


// round()
// round()

// (-3..<10).forEach { i in 
//     print(String((-3..<10).map { j -> Character in 
//         let point = Point(x: j, y: i)
//         return space.contains(point) ? "#" : "."
//     }))
// }