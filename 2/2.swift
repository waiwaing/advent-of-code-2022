import Foundation

extension String: Error {}

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)

func calcMatchScore(opponent: String, me: String) throws -> Int {
    let oppScore = try { switch opponent { case "A": return 1; case "B": return 2; case "C": return 3; default: throw "no" }}()
    let myScore = try { switch me { case "X": return 1; case "Y": return 2; case "Z": return 3; default: throw "no" }}()
    let roundScore = try {
        switch myScore - oppScore {
        case -1, 2: return 0
        case 0: return 3
        case 1, -2: return 6
        default: throw "no"
        }
    }()

    return myScore + roundScore
}

func calcPart2Score(opponent: String, result: String) throws -> Int {
    switch (opponent, result) {
    case ("A", "X"): return 3 + 0
    case ("A", "Y"): return 1 + 3
    case ("A", "Z"): return 2 + 6
    case ("B", "X"): return 1 + 0
    case ("B", "Y"): return 2 + 3
    case ("B", "Z"): return 3 + 6
    case ("C", "X"): return 2 + 0
    case ("C", "Y"): return 3 + 3
    case ("C", "Z"): return 1 + 6
    default: throw "no"
    }
}

let result = try input.split(separator: "\n")
    .map { line -> Int in
        let chars = line.split(separator: " ")
        return try calcMatchScore(opponent: String(chars[0]), me: String(chars[1]))
    }
    .reduce(0, +)

print(result)

let result2 = try input.split(separator: "\n")
    .map { line -> Int in
        let chars = line.split(separator: " ")
        return try calcPart2Score(opponent: String(chars[0]), result: String(chars[1]))
    }
    .reduce(0, +)

print(result2)
