import Foundation

extension String: Error {}
extension Int { init?(_ substring: Substring) { self.init(String(substring)) } }
extension Int { init?(_ char: Character) { self.init(String(char)) } }
extension Dictionary {
    mutating func getOrSet(_ key: Key, _ value: () -> Value) -> Value {
        if self[key] == nil { self[key] = value() }
        return self[key]!
    }
}

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
let width = input.firstIndex(of: "\n")!.utf16Offset(in: input)
let height = input.filter {$0 == "\n"}.count + 1

let grid = input.split(separator: "\n").map { $0.map{Int($0)!} }

func gridAxes<T>(grid: [[Int]], transform: ([Int], Int) -> T) -> [[T]] {
    (0..<height).flatMap{ (currentY: Int) -> [[T]] in (0..<width).map { (currentX: Int) -> [T] in 
        let value = grid[currentY][currentX]
        let r = [
            transform((0..<currentY).map { grid[$0][currentX] }, value),
            transform(((currentY + 1) ..< height).map { grid[$0][currentX] }, value),
            transform((0..<currentX).map { grid[currentY][$0] }, value),
            transform(((currentX + 1) ..< width).map { grid[currentY][$0] }, value)
        ]
        return r
     }}
}

let part1 = gridAxes(grid: grid, transform: {(axis, value) in axis.allSatisfy { $0 < value }})
    .filter { $0.contains(true) }
    .count
print(part1)

var part2 = 0
for currentY in 0..<height {
    for currentX in 0..<width {
        let value = grid[currentY][currentX]
        let up = (0..<currentY).reversed().map { grid[$0][currentX] }.firstIndex { $0 >= value } ?? (currentY - 1)
        let down = ((currentY + 1) ..< height).map { grid[$0][currentX] }.firstIndex { $0 >= value } ?? (height - 1 - currentY - 1)
        let left = (0..<currentX).reversed().map { grid[currentY][$0] }.firstIndex { $0 >= value } ?? (currentX - 1)
        let right = ((currentX + 1) ..< width).map { grid[currentY][$0] }.firstIndex { $0 >= value } ?? (width - 1 - currentX - 1)

        part2 = max(part2, (up + 1) * (down + 1) * (left + 1) * (right + 1))
    }
}

print(part2)