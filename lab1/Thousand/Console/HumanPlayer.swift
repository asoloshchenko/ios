final class HumanPlayer: Player {
    let name: String
    var score = 0

    init(name: String) {
        self.name = name
    }

    func chooseAction(turnPoints: Int, diceLeft: Int) -> Decision {
        while true {
            print("За ход \(turnPoints), костей \(diceLeft). 1 - записать, 2 - бросать дальше")
            print(">> ", terminator: "")
            guard let input = readLine() else {
                return .bank
            }
            switch Int(input) {
            case 1?:
                return .bank
            case 2?:
                return .reroll
            default:
                print("Введите 1 или 2")
            }
        }
    }
}
