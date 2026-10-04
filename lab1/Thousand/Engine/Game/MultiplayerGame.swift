protocol MultiplayerGame: Game {
    var players: [Player] { get }
    func join(player: Player)
}

protocol MultiplayerGameDelegate: GameDelegate {
    func player(_ player: Player, didJoinTheGame game: MultiplayerGame)
    func player(_ player: Player, didTakeAction action: PlayerAction)
}

protocol MultiplayerTurnbasedGameDelegate: TurnbasedGameDelegate, MultiplayerGameDelegate {
    func playerDidStartTurn(_ player: Player)
    func playerDidEndTurn(_ player: Player)
}

extension MultiplayerGameDelegate {
    func player(_ player: Player, didJoinTheGame game: MultiplayerGame) {}
    func player(_ player: Player, didTakeAction action: PlayerAction) {}
}

extension MultiplayerTurnbasedGameDelegate {
    func playerDidStartTurn(_ player: Player) {}
    func playerDidEndTurn(_ player: Player) {}
}
