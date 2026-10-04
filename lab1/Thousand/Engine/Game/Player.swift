protocol Player: AnyObject {
    var name: String { get }
    var score: Int { get set }
    func chooseAction(turnPoints: Int, diceLeft: Int) -> Decision
}

enum Decision {
    case bank
    case reroll
}

enum PlayerAction {
    case scored(points: Int, turnPoints: Int, diceLeft: Int)
    case bust(lostPoints: Int)
    case hotDice
    case cannotBank(target: Int)
    case bank(points: Int)
    case win
}
