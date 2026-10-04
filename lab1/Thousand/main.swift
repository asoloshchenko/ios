let game = Thousand()

let tracker = ThousandTracker()
game.delegate = tracker

for player in ConsoleSetup.askPlayers() {
    game.join(player: player)
}

game.play()
