import Foundation

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)

let deltas: [Int] = input.split(separator: "\n").map{ String($0) }.flatMap { instruction in 
    instruction.starts(with: "addx") ? [0, Int(instruction.split(separator: " ")[1])!] : [0]
}

var signalStrengths = [Int](repeating: 1, count: 300)
deltas.enumerated().dropFirst().forEach { (ix, delta) in
    signalStrengths[ix + 1] = signalStrengths[ix] + delta
}

print(stride(from: 19, to: 230, by: 40).map { signalStrengths[$0] * ($0 + 1) }.reduce(0, +))

[ 0..<40, 40..<80, 80..<120, 120..<160, 160..<200, 200..<240 ].map { 
    $0.map { (ix: Int) in (signalStrengths[ix] - 1 <= ix % 40 && ix % 40 <= signalStrengths[ix] + 1) ? "#" : "." }.reduce("", +)
}.forEach { print($0) }

