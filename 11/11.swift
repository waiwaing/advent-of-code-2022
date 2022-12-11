import Foundation

let input: String = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
let lines: [String] = input.split(separator: "\n").map { String($0) }

class Monkey {
    var items: [Int]
    let operation: (Int) -> Int
    let divisor: Int
    let routing: (Int, Int)
    var inspectionCount: Int = 0

    init(items: String, operation: String, divisor: String, routing: String) {
        self.items = items.split(separator: " ").map { Int($0)! }
        self.divisor = Int(divisor)!
        let routingInts = routing.split(separator: " ").map { Int($0)! }
        self.routing = (routingInts[0], routingInts[1])

        self.operation = { (x: Int) -> Int in
            NSExpression(format: operation.replacingOccurrences(of: "x", with: String(x)))
                .expressionValue(with: nil, context: nil) as! Int
        }
    }
}
func turn(monkeys: [Monkey], monkey: Monkey) -> () {
    monkey.items.forEach { (worryLevel: Int) in
        let newWorryLevel: Int = monkey.operation(worryLevel) / 3
        let newMonkeyId: Int = (newWorryLevel % monkey.divisor == 0) ? monkey.routing.0 : monkey.routing.1
        monkeys[newMonkeyId].items.append(newWorryLevel)
        monkey.inspectionCount += 1
    }
    monkey.items = []
}

func round(monkeys: [Monkey]) -> () {
    monkeys.forEach { turn(monkeys: monkeys, monkey: $0) }
}

let monkeys = (0..<(lines.count / 4)).map {
    Monkey(items: lines[$0 * 4], operation: lines[$0 * 4 + 1], divisor: lines[$0 * 4 + 2], routing: lines[$0 * 4 + 3])
}

(0..<20).forEach { _ in round(monkeys: monkeys) }
print(monkeys.map { $0.inspectionCount }.sorted().reversed().prefix(2).reduce(1, *))
