import Foundation

let input: String = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
struct Point : Hashable {let x: Int; let y: Int}

class Node: Equatable, Hashable {
    let x: Int 
    let y: Int

    var value: Int = 0
    var reachable: [Node] = []
    var distance: Int = Int.max

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

var startingNode: Node?
var endingNode: Node?

let lines: [String] = input.split(separator: "\n").map { String($0) }
let nodes = (0..<lines.count).flatMap { (y: Int) -> [Node] in
    (0..<lines[y].count).map { (x: Int) -> Node in
        let node = Node(x: x, y: y)
        switch  Array(lines[y])[x] {
            case "S": startingNode = node; node.value = 1
            case "E": endingNode = node; node.value = 26
            case (let v): node.value = Int((v.asciiValue ?? 100) - 96)
        }
        return node
    }
}
let nodesDict = Dictionary(uniqueKeysWithValues: nodes.map { node in (Point(x: node.x, y: node.y), node) })

for (nodePoint, node) in nodesDict {
    node.reachable = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        .compactMap { (dx, dy) in nodesDict[Point(x: nodePoint.x + dx, y: nodePoint.y + dy)]}
        .filter { $0.value <= node.value + 1}
}

func dijkstra(startingNode node: Node, allNodes nodes: [Node]) {
    nodes.forEach { $0.distance = Int.max }
    node.distance = 0
    var queue: Set<Node> = [node]

    while queue.count > 0 {
        let currentNode = queue.remove(queue.min(by: { $0.distance < $1.distance })!)!
        currentNode.reachable.forEach {
            $0.distance = min($0.distance, currentNode.distance + 1)
        }

        queue.formUnion(currentNode.reachable.filter { $0.distance > currentNode.distance })
    }
}

dijkstra(startingNode: startingNode!, allNodes: nodes)
print(endingNode!.distance)

print(nodes.filter { $0.value == 1 }.map { potentialStart -> Int in
    dijkstra(startingNode: potentialStart, allNodes: nodes)
    return endingNode!.distance
}.min()!)