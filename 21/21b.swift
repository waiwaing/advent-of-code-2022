import Foundation

indirect enum Expression {
    case op(String, Expression, Expression)
    case num(UInt64)
    case indir(String)
    case unk

    init(_ input: String) {
        if input.contains(" ") {
            let parts = input.split(separator: " ").map { String($0) }
            self = .op(parts[1], .indir(parts[0]), .indir(parts[2]))
        } else {
            self = .num(UInt64(input)!)
        }
    }

    func toS() -> String {
        switch (self) {
            case let .op(x, y, z): return "(" + y.toS() + x + z.toS() + ")"
            case let .num(n): return String(n)
            case .unk: return "x"
            default: return "!" 
        }
    }

// 112*((x-341)/5)
// .op("*", .num(112), .op("/", .op("-", .unk, .num(341)), .num(5))

}

let input: String = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
var cache = Dictionary(uniqueKeysWithValues: input.split(separator: "\n").map { line in 
    let components = line.components(separatedBy: ": ")
    return (String(components[0]), Expression(String(components[1]))) 
})

// func evaluate(_ key: String) -> Int {
//     let result: Int
//     switch cache[key]! {
//         case let .op(op, .indir(a), .indir(b)):
//             switch(op) {
//                 case "+": result = evaluate(a) + evaluate(b)
//                 case "-": result = evaluate(a) - evaluate(b)
//                 case "*": result = evaluate(a) * evaluate(b)
//                 case "/": result = evaluate(a) / evaluate(b)
//                 default: fatalError()
//             }
//         case let .num(a): result = a
//         case let .indir(a): result = evaluate(a)
//         default: fatalError()
//     }
//     return result
// }

func oper(_ op: String, _ a: UInt64, _ b: UInt64) -> UInt64 {
    switch(op) {
        case "+": return a + b
        case "-": return a - b
        case "*": return a * b
        case "/": return a / b
        case "=": return 0
        default: fatalError()
    }
}

func evaluate(_ input: Expression) -> Expression {
    let result: Expression
    print (input.toS())
    print (input)
    switch input {
        case let .op(op, a, b):
            let ax = evaluate(a)
            let bx = evaluate(b)

            switch(op, ax, bx) {
                case let (_, .num(a1), .num(b1)): result = .num(oper(op, a1, b1))
                case let ("+", .num(a1), .op("+", .num(b1), b2)): 
                    result = .op("+", .num(a1 + b1), b2)
                case let ("+", .num(a1), .op("-", .num(b1), b2)): 
                    result = .op("+", .num(a1 - b1), b2)
                case let ("+", .num(a1), .op("-", b1, .num(b2))): 
                    result = .op("+", b1, .num(a1 - b2))
                case let ("+", .op("+", .num(b1), b2), .num(a1)): 
                    result = .op("+", .num(a1 + b1), b2)
                case let ("+", .op("-", .num(b1), b2), .num(a1)): 
                    result = .op("+", .num(a1 - b1), b2)
                case let ("+", .op("-", b1, .num(b2)), .num(a1)): 
                    result = .op("+", b1, .num(a1 - b2))

                case let ("*", .num(a1), .op(oper, b1, b2)) where oper == "+": 
                    let m1 : Expression = evaluate(.op("*", .num(a1), b1))
                    let m2 : Expression = evaluate(.op("*", .num(a1), b2))
                    result = .op(oper, m1, m2)
                case let ("*", .op(oper, b1, b2), .num(a1)) where oper == "+": 
                    let m1 : Expression = evaluate(.op("*", .num(a1), b1))
                    let m2 : Expression = evaluate(.op("*", .num(a1), b2))
                    result = .op(oper, m1, m2)
                // case let ("*", .num(a1), .op(ops, .num(b1), b2)) where ops != "/": 
                //     let m1 : Expression = .num(a1 * b1)
                //     let m2 : Expression = .op("*", .num(a1), b2)
                //     result = .op(ops, m1, m2)
                // case let ("*", .num(a1), .op(ops, b1, .num(b2))): 
                //     result = .op(ops, .op("*", .num(a1), b1), .num(a1 * b2))
                // case let ("*", .op(ops, .num(b1), b2), .num(a1)) where ops != "/":  
                //     result = .op(ops, .num(a1 * b1), .op("*", .num(a1), b2))
                // case let ("*", .op(ops, b1, .num(b2)), .num(a1)) where ops != "/": 
                //     result = .op(ops, .op("*", .num(a1), b1), .num(a1 * b2))
    
                // case let ("*", _, _):
                    // result = .num(3)
                // case let ("*", a1, .op(ops, b1, b2)):
                //     result = .num(3)
                    // result = .op(ops, .op("*", a1, b1), .op("*", a1, b2))
                
                // case let ("/", .op("*", .num(b1), b2), .num(a1)) where b1 % a1 == 0: 
                //     result = .op("*", .num(b1 / a1), b2)
                // case let ("/", .op("*", b1, .num(b2)), .num(a1)) where b2 % a1 == 0: 
                //     result = .op("*", .num(b2 / a1), b1)
  
                default: result = .op(op, ax, bx)
            }

           
        case let .num(a): result = .num(a)
        case let .indir(a):
            cache[a] = evaluate(cache[a]!)
            result = cache[a]!
        case .unk: result = .unk
    }
    // cache
    return result
}

cache["humn"] = .unk
guard case let .op(a, b, c) = cache["root"]! else { fatalError() }
cache["root"] = .op("=", b, c)
print(evaluate(cache["root"]!).toS())

// print(g.toS())
// print(evaluate(g).toS())

(4*(25144232728290-((1057+(5*(((((7576+(8*(((2*(((119+(15*
    ((((((((((722+(((2*((4*(((1275+(((7*(((374+(2*(((((5*(((5040+
        (9*(((1641+(3*(((((2*(112*((x-341)/5)))+71232)+1424)-216)/4)))-257)/10))
    )-15)/5))+560)-911)/3)-345)))/5)-94))+246)/2))/2)-250))-302))+709)/3))/3)-319)*2)-498)*2)+257)+702)/11)-786)
))/8)-20))+408)/2)))-199)/7)-670)/3)))/2)))=42130890593816

((1057+(5*(((((7576+(8*(((2*(((119+(15*
    ((((((((((722+(((2*((4*(((1275+(((7*(((374+(2*(((((5*(((5040+
        (9*(((1641+(3*(((((2*(112*((x-341)/5)))+71232)+1424)-216)/4)))-257)/10))
    )-15)/5))+560)-911)/3)-345)))/5)-94))+246)/2))/2)-250))-302))+709)/3))/3)-319)*2)-498)*2)+257)+702)/11)-786)
))/8)-20))+408)/2)))-199)/7)-670)/3)))/2)=14611510079836

(7576+(8*(((2*(((119+(15*
    ((((((((((722+(((2*((4*(((1275+(((7*(((374+(2*(((((5*(((5040+
        (9*(((1641+(3*(((((2*(112*((x-341)/5)))+71232)+1424)-216)/4)))-257)/10))
    )-15)/5))+560)-911)/3)-345)))/5)-94))+246)/2))/2)-250))-302))+709)/3))/3)-319)*2)-498)*2)+257)+702)/11)-786)
))/8)-20))+408)/2)))=122736684671072

((((((((((722+(((2*((4*(((1275+(((7*(((374+(2*(((((5*(((5040+
    (9*(((1641+(3*(((((2*(112*((x-341)/5)))+71232)+1424)-216)/4)))-257)/10))
)-15)/5))+560)-911)/3)-345)))/5)-94))+246)/2))/2)-250))-302))+709)/3))/3)-319)*2)-498)*2)+257)+702)/11)-786)
=8182445644127

(722+(((2*((4*(((1275+(((7*(((374+(2*(((((5*(((5040+
    (9*(((1641+(3*(((((2*(112*((x-341)/5)))+71232)+1424)-216)/4)))-257)/10))
)-15)/5))+560)-911)/3)-345)))/5)-94))+246)/2))/2)-250))-302))+709)/3))
=67505176571517

(((374+(2*(((((5*(((5040+
    (9*(((1641+(3*(((((2*(112*((x-341)/5)))+71232)+1424)-216)/4)))-257)/10))
)-15)/5))+560)-911)/3)-345)))/5)-94)
=14465394979192

(5*(((5040+
    (9*(((1641+(3*(((((2*(112*((x-341)/5)))+71232)+1424)-216)/4)))-257)/10))
)-15)/5))
=108490462345470

((5040+
    (9*(((1641+(3*(((((2*(112*((x-341)/5)))+71232)+1424)-216)/4)))-257)/10))
)-15)
=108490462345470

x = 3587647562851