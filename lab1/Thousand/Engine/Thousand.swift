protocol ThousandDelegate: MultiplayerTurnbasedGameDelegate, DiceGameDelegate {}

final class Thousand: DiceGame, MultiplayerGame, TurnbasedGame {
    static let diceCount = 5

    let name = "Тысяча"
    let winningScore: Int
    let openingThreshold: Int
    let pits: [Range<Int>]

    weak var delegate: ThousandDelegate?

    init(winningScore: Int, openingThreshold: Int, pits: [Range<Int>], dice: Dice) {
        self.winningScore = winningScore
        self.openingThreshold = openingThreshold
        self.pits = pits
        self.dice = dice
    }

    convenience init(dice: Dice = Dice()) {
        self.init(winningScore: 1000, openingThreshold: 50, pits: [200..<300, 600..<700], dice: dice)
    }

    let dice: Dice

    private(set) var players: [Player] = []

    func join(player: Player) {
        players.append(player)
        delegate?.player(player, didJoinTheGame: self)
    }

    private(set) var turns = 0

    private let maxTurns = 500

    var hasEnded: Bool {
        winner != nil || turns >= maxTurns
    }

    private var winner: Player? {
        players.first { $0.score >= winningScore }
    }

    func start() {
        precondition(players.count >= 2, "Нужно минимум 2 игрока")
        for player in players {
            player.score = 0
        }
        delegate?.gameDidStart(self)
    }

    func makeTurn() {
        turns += 1
        delegate?.gameDidStartTurn(self)
        for player in players {
            playerMakeTurn(player)
            if winner != nil {
                break
            }
        }
        delegate?.gameDidEndTurn(self)
    }

    func end() {
        if let champion = winner ?? players.max(by: { $0.score < $1.score }) {
            delegate?.player(champion, didTakeAction: .win)
        }
        delegate?.gameDidEnd(self)
    }

    private enum TurnPhase {
        case rolling
        case hotDice
        case deciding
        case busted
        case banked
    }

    private func playerMakeTurn(_ player: Player) {
        delegate?.playerDidStartTurn(player)
        defer { delegate?.playerDidEndTurn(player) }

        var phase = TurnPhase.rolling
        var turnPoints = 0
        var diceLeft = Self.diceCount

        while true {
            switch phase {
            case .rolling:
                let faces = dice.roll(count: diceLeft)
                delegate?.game(self, didDiceRoll: faces)
                let roll = Scoring.score(faces)
                guard roll.points > 0 else {
                    phase = .busted
                    continue
                }
                turnPoints += roll.points
                diceLeft -= roll.diceUsed
                delegate?.player(player, didTakeAction: .scored(points: roll.points, turnPoints: turnPoints, diceLeft: diceLeft))

                if diceLeft == 0 {
                    phase = .hotDice
                } else if let target = bankTarget(for: player.score), player.score + turnPoints < target {
                    delegate?.player(player, didTakeAction: .cannotBank(target: target))
                } else {
                    phase = .deciding
                }

            case .hotDice:
                diceLeft = Self.diceCount
                delegate?.player(player, didTakeAction: .hotDice)
                phase = .rolling

            case .deciding:
                switch player.chooseAction(turnPoints: turnPoints, diceLeft: diceLeft) {
                case .bank:
                    phase = .banked
                case .reroll:
                    phase = .rolling
                }

            case .busted:
                delegate?.player(player, didTakeAction: .bust(lostPoints: turnPoints))
                return

            case .banked:
                player.score += turnPoints
                delegate?.player(player, didTakeAction: .bank(points: turnPoints))
                return
            }
        }
    }

    private func bankTarget(for score: Int) -> Int? {
        if score == 0 {
            return openingThreshold
        }
        return pits.first { $0.contains(score) }?.upperBound
    }
}
