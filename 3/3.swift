import Foundation

extension String: Error {}

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)

func priority(contents: String) -> Int {
    let compartmentSize = contents.count / 2
    let middleIndex = contents.index(contents.startIndex, offsetBy: compartmentSize)
    let firstCompartment = Set(contents[..<middleIndex].map { c -> Character in c })
    let secondCompartment = Set(contents[middleIndex...].map { c -> Character in c })

    let common = firstCompartment.intersection(secondCompartment).first!
    let asciiValue = Int(common.asciiValue!)

    return common.isUppercase ? asciiValue - 64 + 26 : asciiValue - 96
}

func groupPriority(contents: [String]) -> Int {
    let sets = contents.map { Set($0.map { c -> Character in c }) }
    let common = sets[0].intersection(sets[1]).intersection(sets[2]).first!
    let asciiValue = Int(common.asciiValue!)
    return common.isUppercase ? asciiValue - 64 + 26 : asciiValue - 96
}

let result = input.split(separator: "\n")
    .map { priority(contents: String($0)) }
    .reduce(0, +)

print(result)

let result2 = input.split(separator: "\n")
    .map { String($0) }
    .chunked(into: 3)
    .map { groupPriority(contents: $0)}
    .reduce(0, +)

print(result2)

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}