import Foundation

extension String: Error {}

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)

func is_fully_contained(line: String) -> Bool {
    let elves = line.split(separator: ",")
    .map { elf -> ClosedRange<Int> in
        let bounds = elf.split(separator: "-").map { Int(String($0)) }
        return bounds[0]!...bounds[1]!
    }

    return (elves[0].lowerBound <= elves[1].lowerBound && elves[0].upperBound >= elves[1].upperBound) ||
           (elves[1].lowerBound <= elves[0].lowerBound && elves[1].upperBound >= elves[0].upperBound)
}

func overlaps(line: String) -> Bool {
    let elves = line.split(separator: ",")
    .map { elf -> ClosedRange<Int> in
        let bounds = elf.split(separator: "-").map { Int(String($0)) }
        return bounds[0]!...bounds[1]!
    }

    return elves[0].overlaps(elves[1])
}


let result = input.split(separator: "\n")
    .map { is_fully_contained(line: String($0)) }
    .filter { $0 }
    .count 

print(result)

let result2 = input.split(separator: "\n")
    .map { overlaps(line: String($0)) }
    .filter { $0 }
    .count 

print(result2)

