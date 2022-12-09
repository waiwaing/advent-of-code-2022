import Foundation

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
let grid = input.split(separator: "\n").map { $0.map{Int(String($0))!} }

func gridAxes<T>(grid: [[Int]], transform: ([Int], Int) -> T) -> [[T]] {
    (0 ..< grid.count).flatMap{ y in (0 ..< grid[0].count).map { x in 
        let value = grid[y][x]
        return [
            transform((0 ..< y).reversed().map { grid[$0][x] }, value), // up
            transform(((y + 1) ..< grid.count).map { grid[$0][x] }, value), // down
            transform((0 ..< x).reversed().map { grid[y][$0] }, value), // left
            transform(((x + 1) ..< grid[0].count).map { grid[y][$0] }, value) // right
        ]
     }}
}

let part1 = gridAxes(grid: grid, transform: {(axis, value) in axis.allSatisfy { $0 < value }})
    .filter { $0.contains(true) }.count

let part2 = gridAxes(grid: grid, transform: {(axis, value) in 
        axis.firstIndex { $0 >= value }.map { $0 + 1 } ?? axis.count
    }).map { $0.reduce(1, *) }.max()!

print(part1)
print(part2)