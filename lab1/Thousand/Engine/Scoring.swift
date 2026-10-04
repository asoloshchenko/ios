struct RollScore {
    let points: Int
    let diceUsed: Int
}

enum Scoring {
    private static let faceValue: [Int: Int] = [1: 10, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6]
    private static let comboMultiplier: [Int: Int] = [3: 10, 4: 20, 5: 100]

    static func score(_ faces: [Int]) -> RollScore {
        var counts: [Int: Int] = [:]
        for face in faces {
            counts[face, default: 0] += 1
        }

        if faces.count == 5 {
            if isStraight(counts, from: 1, to: 5) {
                return RollScore(points: 125, diceUsed: 5)
            }
            if isStraight(counts, from: 2, to: 6) {
                return RollScore(points: 250, diceUsed: 5)
            }
        }

        var points = 0
        var diceUsed = 0

        for (face, count) in counts {
            if count > 2 {
                points += (faceValue[face] ?? 0) * (comboMultiplier[count] ?? 0)
                diceUsed += count
            } else if face == 1 || face == 5 {
                points += (faceValue[face] ?? 0) * count
                diceUsed += count
            }
        }

        return RollScore(points: points, diceUsed: diceUsed)
    }

    private static func isStraight(_ counts: [Int: Int], from low: Int, to high: Int) -> Bool {
        counts.count == 5 && counts.keys.min() == low && counts.keys.max() == high
    }
}
