final class ThousandTracker: ThousandDelegate {
    private static let diceFaces = [
        ["[     ]", "[  0  ]", "[     ]"],
        ["[0    ]", "[     ]", "[    0]"],
        ["[0    ]", "[  0  ]", "[    0]"],
        ["[0   0]", "[     ]", "[0   0]"],
        ["[0   0]", "[  0  ]", "[0   0]"],
        ["[0   0]", "[0   0]", "[0   0]"],
    ]

    func gameDidStart(_ game: Game) {
        print("Начинается игра «\(game.name)»")
    }

    func player(_ player: Player, didJoinTheGame game: MultiplayerGame) {
        print("\(player.name) присоединяется к игре")
    }

    func gameDidStartTurn(_ game: TurnbasedGame) {
        print("\n===== Раунд \(game.turns) =====")
    }

    func playerDidStartTurn(_ player: Player) {
        print("\n--- Ход: \(player.name) (\(player.score) очков) ---")
    }

    func game(_ game: DiceGame, didDiceRoll faces: [Int]) {
        for row in 0..<3 {
            print(faces.map { Self.diceFaces[$0 - 1][row] }.joined(separator: " "))
        }
    }

    func player(_ player: Player, didTakeAction action: PlayerAction) {
        switch action {
        case let .scored(points, turnPoints, diceLeft):
            print("Бросок: +\(points) | за ход: \(turnPoints), осталось костей: \(diceLeft)")
        case let .bust(lostPoints):
            print("💥 Пусто! \(player.name) теряет \(lostPoints) очков хода")
        case .hotDice:
            print("🔥 Все кости в зачёте, \(player.name) бросает все 5 заново")
        case let .cannotBank(target):
            print("Записать нельзя: нужно дойти до \(target)")
        case let .bank(points):
            print("💰 \(player.name) записывает \(points), итого \(player.score)")
        case .win:
            print("\n🎉 \(player.name) побеждает!")
        }
    }

    func gameDidEnd(_ game: Game) {
        guard let game = game as? MultiplayerGame & TurnbasedGame else {
            return
        }
        print("Игра длилась \(game.turns) раундов")
        for player in game.players {
            print("  \(player.name): \(player.score)")
        }
    }
}
