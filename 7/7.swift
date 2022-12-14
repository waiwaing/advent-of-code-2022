import Foundation

extension String: Error {}
extension Int { init?(substring: Substring) { self.init(String(substring)) } }
extension Dictionary {
    mutating func getOrSet(_ key: Key, _ value: () -> Value) -> Value {
        if self[key] == nil { self[key] = value() }
        return self[key]!
    }
}

let input = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)

class Directory { 
    var contents: [String: DirectoryItem] = [:] 
    var parent: Directory? = nil

    var totalSize: Int {
        contents.values.map { switch $0 {
            case .directory(let directory): return directory.totalSize
            case .file(let file): return file.size
        }}.reduce(0, +)
    }
}

struct File { let size: Int }

enum DirectoryItem {
    case directory (Directory)
    case file (File)
}

let root = Directory()
var currentDirectory = root

func tryCreateDirectory(parent: Directory, name: String) -> Directory {
    guard case .directory(let directory) = (parent.contents.getOrSet(name, { .directory(Directory()) })) 
        else { fatalError("Directory is not directory") }

    directory.parent = parent
    return directory
}

for line in input.split(separator: "\n") {
    switch String(line) {
        case "$ cd /": 
            currentDirectory = root
        case "$ cd ..":
            currentDirectory = currentDirectory.parent!
        case _ where line.starts(with: "$ cd "):
            currentDirectory = tryCreateDirectory(parent: currentDirectory, name: String(line.dropFirst(5)))
        case "$ ls":
            break
        case _ where line.starts(with: "dir "):
            _ = tryCreateDirectory(parent: currentDirectory, name: String(line.dropFirst(4)))
        default:
            let info = line.split(separator: " ").map { String($0) }
            _ = currentDirectory.contents.getOrSet(info[1], { .file(File(size: Int(info[0])!))} )
    }
}

var stack = [root]
var answer = 0

while !stack.isEmpty {
    let current = stack.removeFirst()
    stack.append(contentsOf: current.contents.values.compactMap { x -> Directory? in
        if case .directory(let directory) = x {return directory} else {return nil}
    })

    answer += current.totalSize < 100000 ? current.totalSize : 0
}

print(answer)

var minimumToDelete = root.totalSize - 40000000
stack = [root]
answer = 70000000

while !stack.isEmpty {
    let current = stack.removeFirst()
    stack.append(contentsOf: current.contents.values.compactMap { x -> Directory? in
        if case .directory(let directory) = x {return directory} else {return nil}
    })

    if (current.totalSize >= minimumToDelete && current.totalSize < answer) {
        answer = current.totalSize
    } 
}
print(answer)