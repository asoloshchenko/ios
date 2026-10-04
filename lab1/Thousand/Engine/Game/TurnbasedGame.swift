protocol TurnbasedGame: Game {
    var turns: Int { get }
    var hasEnded: Bool { get }
    func start()
    func makeTurn()
    func end()
}

protocol TurnbasedGameDelegate: GameDelegate {
    func gameDidStartTurn(_ game: TurnbasedGame)
    func gameDidEndTurn(_ game: TurnbasedGame)
}

extension TurnbasedGame {
    func play() {
        start()
        while !hasEnded {
            makeTurn()
        }
        end()
    }
}

extension TurnbasedGameDelegate {
    func gameDidStartTurn(_ game: TurnbasedGame) {}
    func gameDidEndTurn(_ game: TurnbasedGame) {}
}
