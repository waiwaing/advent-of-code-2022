import Foundation

extension String: Error {}
extension Int { 
    init?(substring: Substring) {
        self.init(String(substring))
    }
}

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
let indices = Array(input.indices)

for i in 3..<input.count {
    if((Set(((i-3)...i).map { input[indices[$0]] }).count) == 4) {
        print(i + 1)
        break
    }
}

for i in 13..<input.count {
    if((Set(((i-13)...i).map { input[indices[$0]] }).count) == 14) {
        print(i + 1)
        break
    }
}