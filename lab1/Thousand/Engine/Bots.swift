final class CautiousCpu: Player {
    let name: String
    var score = 0
    private let enoughPoints: Int

    init(name: String, enoughPoints: Int = 100) {
        self.name = "Bot " + name
        self.enoughPoints = enoughPoints
    }

    func chooseAction(turnPoints: Int, diceLeft: Int) -> Decision {
        diceLeft <= 2 || turnPoints >= enoughPoints ? .bank : .reroll
    }
}

final class GreedyCpu: Player {
    let name: String
    var score = 0

    init(name: String) {
        self.name = "Bot " + name
    }

    func chooseAction(turnPoints: Int, diceLeft: Int) -> Decision {
        diceLeft >= 2 && turnPoints < 300 ? .reroll : .bank
    }
}
