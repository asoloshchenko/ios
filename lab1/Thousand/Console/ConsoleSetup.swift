enum ConsoleSetup {
    static func askPlayers() -> [Player] {
        if askNumber("1 - партия ботов, 2 - настроить игроков", in: 1...2) == 1 {
            return [CautiousCpu(name: names[0]), GreedyCpu(name: names[1]), CautiousCpu(name: names[2], enoughPoints: 200)]
        }

        let count = askNumber("Сколько игроков? (2-6)", in: 2...6)
        var freeNames = names.shuffled()
        var players: [Player] = []

        for i in 1...count {
            let cpuName = freeNames.popLast() ?? "#\(i)"
            print("\nИгрок #\(i):")
            switch askNumber("1 - человек, 2 - осторожный бот, 3 - жадный бот", in: 1...3) {
            case 1:
                players.append(HumanPlayer(name: askName(fallback: cpuName)))
            case 2:
                players.append(CautiousCpu(name: cpuName))
            default:
                players.append(GreedyCpu(name: cpuName))
            }
        }
        return players
    }

    private static func askNumber(_ prompt: String, in range: ClosedRange<Int>) -> Int {
        while true {
            print(prompt)
            print(">> ", terminator: "")
            guard let input = readLine() else {
                return range.lowerBound
            }
            if let number = Int(input), range.contains(number) {
                return number
            }
            print("Нужно число от \(range.lowerBound) до \(range.upperBound)")
        }
    }

    private static func askName(fallback: String) -> String {
        print("Введите имя: ", terminator: "")
        guard let input = readLine(), !input.isEmpty else {
            return fallback
        }
        return input
    }
}
