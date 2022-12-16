import Foundation

struct Point : Hashable {
    let x: Int; let y: Int; 
    init(_ x: Int, _ y: Int) { self.x = x; self.y = y }
    static func distance(_ a: Point, _ b: Point) -> Int { abs(a.x - b.x) + abs(a.y - b.y) }
}

struct SensorBeacon { 
    let sensor: Point; let beacon: Point; let distance: Int;
    init(sensor: Point, beacon: Point) { 
        self.sensor = sensor; self.beacon = beacon; self.distance = Point.distance(sensor, beacon) 
    }
}

let row = 2000000
let input: String = try String(decoding: FileHandle(forReadingAtPath: "input.txt")!.readToEnd()!, as: UTF8.self)
let sensorBeacons = input.split(separator: "\n").map { line in
    let components = line.split(separator: " ").map { Int(String($0))! }
    return SensorBeacon(sensor: Point(components[0], components[1]), beacon: Point(components[2], components[3]))
}

extension ClosedRange<Int> {
    func split(atRemoving splitPoint: Int) -> [ClosedRange] {
        if self.lowerBound > splitPoint || self.upperBound < splitPoint { return [self] }
        if self.lowerBound == self.upperBound { return [] }
        if self.lowerBound == splitPoint { return [(self.lowerBound + 1) ... (self.upperBound)] }
        if self.upperBound == splitPoint { return [(self.lowerBound) ... (self.upperBound + 1)] }
        return [self.lowerBound ... splitPoint - 1, splitPoint + 1 ... self.upperBound]
    }
}

func getExcludedRange(_ sensorBeacon: SensorBeacon, _ y: Int) -> Optional<ClosedRange<Int>> {
    let dx = sensorBeacon.distance - abs(sensorBeacon.sensor.y - y)
    if (dx < 0) { return nil }
    return (sensorBeacon.sensor.x - dx)...(sensorBeacon.sensor.x + dx)
}

func combineOverlappingRanges<T>(_ a: ClosedRange<T>, _ b: ClosedRange<T>) -> ClosedRange<T> {
    // if (!a.overlaps(b)) { fatalError("Non-overlapping ranges") }
    switch (a.lowerBound < b.lowerBound, a.upperBound < b.upperBound) {
        case (true, true): return (a.lowerBound...b.upperBound)
        case (true, false): return (a.lowerBound...a.upperBound)
        case (false, true): return (b.lowerBound...b.upperBound)
        case (false, false): return (b.lowerBound...a.upperBound)
    }
}

func combineRanges(ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    ranges.sorted(by: { $0.lowerBound < $1.lowerBound }).reduce([], { (acc, cur) in
        if (acc.last?.overlaps(cur) == true) { return acc.dropLast() + [combineOverlappingRanges(acc.last!, cur)] }
        else { return acc + [cur] }
    })
}

// Part 1
var ranges = combineRanges(ranges: sensorBeacons.compactMap { getExcludedRange($0,  row) })
sensorBeacons.flatMap { [$0.sensor, $0.beacon] }.filter { $0.y == row }.map { $0.x }.forEach { splitPoint in
    ranges = ranges.flatMap { range in range.split(atRemoving: splitPoint) }
}
print(ranges.map { $0.upperBound - $0.lowerBound + 1}.reduce(0, +))

// Part 2
let possibilities = (0...4000000).flatMap { (y: Int) -> [Point] in 
    if(y % 40000 == 0) { print("...\(y / 40000)%") }
    ranges = combineRanges(ranges: sensorBeacons.compactMap { getExcludedRange($0, y) })
    if (ranges.contains { range in range.lowerBound <= 0 && range.upperBound >= 4000000 }) { return [] }
    else { return (0...4000000).filter { x in ranges.allSatisfy {range in !range.contains(x)} }.map { Point($0, y)} }
}
assert(possibilities.count == 1)
print(possibilities[0].x * 4000000 + possibilities[0].y)
print(3138881 * 4000000 + 3364986)
