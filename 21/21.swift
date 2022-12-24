import Foundation

indirect enum Expression {
    case sum(Expression, Expression)
    case diff(Expression, Expression)
    case prod(Expression, Expression)
    case div(Expression, Expression)
    case num(Int)
    case indir(String)
    case unk

    init(_ input: String) {
        if input.contains(" ") {
            let parts = input.split(separator: " ").map { String($0) }
            switch parts[1] {
                case "+": self = .sum(.indir(parts[0]), .indir(parts[2]))
                case "-": self = .diff(.indir(parts[0]), .indir(parts[2]))
                case "*": self = .prod(.indir(parts[0]), .indir(parts[2]))
                case "/": self = .div(.indir(parts[0]), .indir(parts[2]))
                default: fatalError()
            }
        } else {
            self = .num(Int(input)!)
        }
    }
}

let input: String = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
var cache = Dictionary(uniqueKeysWithValues: input.split(separator: "\n").map { line in 
    let components = line.components(separatedBy: ": ")
    return (String(components[0]), Expression(String(components[1]))) 
})

func evaluate(_ key: String) -> Int {
    let result: Int
    switch cache[key]! {
        case let .sum(.indir(a), .indir(b)): result = evaluate(a) + evaluate(b)
        case let .diff(.indir(a), .indir(b)): result = evaluate(a) - evaluate(b)
        case let .prod(.indir(a), .indir(b)): result = evaluate(a) * evaluate(b)
        case let .div(.indir(a), .indir(b)): result = evaluate(a) / evaluate(b)
        case let .num(a): result = a
        case let .indir(a): result = evaluate(a)
        default: fatalError()
    }
    // cache[key] = .num(result)
    return result
}

print(evaluate("root"))

