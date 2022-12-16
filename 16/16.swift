import Foundation

extension Dictionary {
    mutating func getOrSet(_ key: Key, _ value: () -> Value) -> Value {
        if self[key] == nil { self[key] = value() }
        return self[key]!
    }
}

class Node: Equatable {  
    let name: String
    var flowRate: Int = -1
    var destinations: [String: (Node, Int)] = [:]

    init(_ name: String) { self.name = name }

    static func ==(a: Node, b: Node) -> Bool {
        return a.name == b.name
    }
}

var nodesDict: [String: Node] = [:] 

let input: String = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
input.split(separator: "\n").forEach { line in
    let components = line.split(separator: " ")
    let node = nodesDict.getOrSet(String(components[0]), { Node(String(components[0])) })
    node.flowRate = Int(String(components[1]))!
    node.destinations = Dictionary(uniqueKeysWithValues: components[2...].map { destName in 
        (String(destName), (nodesDict.getOrSet(String(destName), { Node(String(destName)) }), 1)) 
    })
}

nodesDict.map { $0.value }.filter { node in node.flowRate == 0 && node.name != "AA"}.forEach { (noFlowNode: Node)in
    let origins: [Node] = nodesDict.map { $0.value }.filter { (potentialOrigin: Node) in 
        potentialOrigin.destinations.map{ $0.value.0 }.contains(noFlowNode)
    }
    
    origins.forEach { (originNode: Node) -> Void in 
        noFlowNode.destinations.forEach { (destNodeName: String, destinationTuple: (Node, Int)) -> Void in 
            let newCost =  originNode.destinations[noFlowNode.name]!.1 + noFlowNode.destinations[destNodeName]!.1

            if originNode.name == destNodeName { return }

            if let destTuple = originNode.destinations[destNodeName] {
                let currentCost = destTuple.1
                if (newCost < currentCost) {
                    originNode.destinations[destNodeName] = (destinationTuple.0, newCost)
                }
            } else {
                originNode.destinations[destNodeName] = (destinationTuple.0, newCost)
            }
        }
        originNode.destinations[noFlowNode.name] = nil
    }

    nodesDict[noFlowNode.name] = nil
}

var pathCosts: [String: [String: Int]] = Dictionary(uniqueKeysWithValues: nodesDict.keys.map { ($0, [:]) })

nodesDict.values.forEach { (source) in
    nodesDict.values.forEach { (sink) in 
        pathCosts[source.name]![sink.name] = 1000
    }
}

nodesDict.values.forEach { (source) in
    source.destinations.values.forEach { (sink, cost) in
        pathCosts[source.name]![sink.name] = cost
    }
    pathCosts[source.name]![source.name] = 0
}

nodesDict.values.forEach{ k in
    nodesDict.values.forEach { i in 
        nodesDict.values.forEach { j in 
            if pathCosts[i.name]![j.name]! > pathCosts[i.name]![k.name]! + pathCosts[k.name]![j.name]! {
                pathCosts[i.name]![j.name] = pathCosts[i.name]![k.name]! + pathCosts[k.name]![j.name]!
            }
        }
    }
}

func permutations<T>(_ n: Int, _ a: inout Array<T>, _ acc: inout [[T]]) {
    if n == 1 { acc.append(a); return}
    for i in 0..<n-1 {
        permutations(n-1, &a, &acc)
        a.swapAt(n-1, (n%2 == 1) ? 0 : i)
    }
    permutations(n-1, &a, &acc)
}

var s = Array(nodesDict.values.map{$0.name}.filter { $0 != "AA" })
var allPaths: [[String]] = []
permutations(s.count, &s, &allPaths)
allPaths = allPaths.map { ["AA"] + $0 }

let answer = allPaths.map { path -> Int in
    var timeLeft = 30
    var pressureReleased = 0
    var currentNodeName = path[0]
    var nextNodeIndex = 1

    while(nextNodeIndex != path.count) {
        let nextNodeName: String = path[nextNodeIndex]
        let movementCost = pathCosts[currentNodeName]![nextNodeName]!
        timeLeft -= movementCost
        timeLeft -= 1

        if(timeLeft < 0) { break }

        pressureReleased += nodesDict[nextNodeName]!.flowRate * timeLeft
        currentNodeName = nextNodeName
        nextNodeIndex += 1
    }

    return pressureReleased
}.max()!

print(answer)
