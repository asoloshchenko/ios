final class Dice {
    let sides: Int
    private var generator: any RandomNumberGenerator

    init(sides: Int = 6, generator: any RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.sides = sides
        self.generator = generator
    }

    func roll(count: Int) -> [Int] {
        (0..<count).map { _ in Int.random(in: 1...sides, using: &generator) }
    }
}
