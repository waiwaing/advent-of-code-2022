
import Foundation

struct Point : Hashable {let x: Int; let y: Int}
var grid: [[Character]] = Array(repeating: Array(repeating: ".", count: 1000), count: 200)

let input: String = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
input.split(separator: "\n").flatMap { line in
    let nodes = line.components(separatedBy: " -> ").map { $0.split(separator: ",") }.map { Point(x: Int($0[0])!, y: Int($0[1])!) }
    return zip(nodes, nodes.dropFirst())
}.forEach { (a: Point, b: Point) in 
    if (a.x == b.x) { (min(a.y, b.y)...max(a.y, b.y)).forEach { grid[$0][a.x] = "#" } }
    if (a.y == b.y) { (min(a.x, b.x)...max(a.x, b.x)).forEach { grid[a.y][$0] = "#" } }
}

func sandFinalPoint(grid: [[Character]], curPoint: Point, lowestPoint: Int) -> Optional<Point> {
    if (curPoint.y >= lowestPoint || grid[curPoint.y][curPoint.x] != ".") { return nil }

    if let newX = [curPoint.x, curPoint.x - 1, curPoint.x + 1].first(where: { grid[curPoint.y + 1][$0] == "." }) {
        return sandFinalPoint(grid: grid, curPoint: Point(x: newX, y: curPoint.y + 1), lowestPoint: lowestPoint)
    } else { return curPoint }
}

let abyssStart = grid.lastIndex(where: { row in row.contains("#") })! + 1

var sand = 0
while let sandLocation = sandFinalPoint(grid: grid, curPoint: Point(x: 500, y: 0), lowestPoint: abyssStart) {
    grid[sandLocation.y][sandLocation.x] = "o"
    sand += 1
}
print(sand)

(0..<1000).forEach { grid[abyssStart + 1][$0] = "#" }
while let sandLocation = sandFinalPoint(grid: grid, curPoint: Point(x: 500, y: 0), lowestPoint: abyssStart + 2) {
    grid[sandLocation.y][sandLocation.x] = "o"
    sand += 1
}
print(sand)

print(grid[0..<200].map { row in row[450...549].map { String($0) }.reduce("", +) }.joined(separator: "\n") )
