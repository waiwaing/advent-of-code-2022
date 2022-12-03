import Foundation

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)

let elves = input.split(separator: "\n\n")
let elfCalories = elves.map { elf -> Int in
    elf.split(separator: "\n")
        .map { str -> Int in Int(str)! }
        .reduce(0, +)
}

print(elfCalories.max()!)

let biggest3Elves = elfCalories.sorted(by: >)[0 ... 2].reduce(0, +)
print(biggest3Elves)
