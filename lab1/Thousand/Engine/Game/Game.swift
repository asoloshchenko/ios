protocol Game {
    var name: String { get }
    func play()
}

protocol GameDelegate: AnyObject {
    func gameDidStart(_ game: Game)
    func gameDidEnd(_ game: Game)
}

extension GameDelegate {
    func gameDidStart(_ game: Game) {}
    func gameDidEnd(_ game: Game) {}
}
