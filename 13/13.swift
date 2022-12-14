import Foundation

let input: String = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
extension Int { init?(_ substring: Character) { self.init(String(substring)) } }
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { Array(self[$0 ..< Swift.min($0 + size, count)]) }
    }
}

enum PacketContent : Comparable {
    case List([PacketContent])
    case Int(Int)

    static func < (lhs: PacketContent, rhs: PacketContent) -> Bool {
        switch (lhs, rhs) {
            case let (.Int(x), .Int(y)): return x < y
            case let (.List(x), .List(y)):
                for i in 0 ..< x.count {
                    if (i >= y.count) { return false }
                    if (x[i] != y[i]) { return x[i] < y[i] }
                }
                return true
            case let (.Int(x), .List(y)): return .List([.Int(x)]) < .List(y)
            case let (.List(x), .Int(y)): return .List(x) < .List([.Int(y)])
        }
    }
}

func extractListEndingIndex(characters: [Character], startingIndex: Int) -> Int {
    var nesting = 0
    for i in startingIndex..<characters.count {
        if (characters[i] == "[") { nesting += 1 }
        if (characters[i] == "]") { nesting -= 1 }
        if (nesting == 0) { return i }
    }
    fatalError()
}

func parse(contents: String) -> PacketContent {
    let characters = Array(contents)
    if "0123456789".contains(characters[0]) {
        return .Int(Int(contents)!)
    }
    
    var elements: [PacketContent] = []
    var elementStartIndex = 1 // characters[0] == "["
    while elementStartIndex < characters.count {
        let elementLength: Int = characters[elementStartIndex] == "[" ? 
            extractListEndingIndex(characters: Array(characters[elementStartIndex...]), startingIndex: 0) : 
            ((Array(characters[elementStartIndex...]).firstIndex(of: ",") ?? characters.count - elementStartIndex - 1) - 1)

        if (elementLength >= 0) {
            elements.append(parse(contents: String(characters[elementStartIndex ... elementStartIndex + elementLength])))
        }
        
        elementStartIndex += elementLength + 2
    }

    return .List(elements)
}

let inputPackets = input.split(separator: "\n").map { parse(contents: String($0)) }
print(inputPackets.chunked(into: 2).enumerated().compactMap { 
    (i, element) in element[0] < element[1] ? i + 1 : nil
}.reduce(0, +))

let dividerElements = [ parse(contents: "[[2]]"), parse(contents: "[[6]]") ]
let part2Packets = (inputPackets + dividerElements).sorted()
print(dividerElements.map { part2Packets.firstIndex(of: $0)! + 1 }.reduce(1, *))
