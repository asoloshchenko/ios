protocol DiceGame: Game {
    var dice: Dice { get }
}

protocol DiceGameDelegate: GameDelegate {
    func game(_ game: DiceGame, didDiceRoll faces: [Int])
}

extension DiceGameDelegate {
    func game(_ game: DiceGame, didDiceRoll faces: [Int]) {}
}
