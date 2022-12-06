import Foundation

extension String: Error {}
extension Int { 
    init?(substring: Substring) {
        self.init(String(substring))
    }
}

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
let inputLines = input.split(separator: "\n").map{String($0)}

let columns = 9
let height = 8

func parseCrates(diagram: [String]) -> [[Character]] {
    let layers = diagram.map { line -> [Character] in
        let lineCh = Array(line)
        return stride(from: 1, through: columns * 4, by: 4).map { lineCh[$0] }        
    }

    return (0..<columns).map { c in (0..<height).map { h in layers[h][c] }.filter { $0 != " " }.reversed() }
}

func moveCrates(_ state: inout[[Character]], _ from: Int, _ to: Int, _ count: Int) {
    state[to - 1].append(contentsOf: state[from-1].suffix(count))
    state[from - 1].removeLast(count)
}

func runInstruction(_ state: inout[[Character]], _ instruction: String) {
    let instructionComponents = instruction.split(separator: " ")
    moveCrates(&state, Int(instructionComponents[3])!, Int(instructionComponents[5])!, Int(instructionComponents[1])!) 
}

var crates = parseCrates(diagram: Array(inputLines.prefix(height)))
inputLines.dropFirst(height + 1).forEach { runInstruction(&crates, $0) }
print(crates.reduce("", { acc, stack in  acc + String(stack.last!)}))
