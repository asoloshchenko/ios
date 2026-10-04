//
//  SimpleCalculator.swift
//  calculator
//

import Foundation

/// Простая реализация калькулятора.
/// Правое значение хранится строкой – так проще считать символы и знаки после запятой.
public class SimpleCalculator: Calculator {

    public weak var delegate: CalculatorDelegate?

    let inputLength: UInt
    let maxFraction: UInt

    public private(set) var result: Double?
    public private(set) var operation: Operation?

    /// Правое значение в виде строки, например "-12.05"
    var inputString: String?

    public required init(inputLength len: UInt, maxFraction frac: UInt) {
        inputLength = len
        maxFraction = frac
    }

    public var input: Double? {
        guard let s = inputString else { return nil }
        return Double(s)
    }

    public var hasPoint: Bool {
        return inputString?.contains(".") ?? false
    }

    public var fractionDigits: UInt {
        return SimpleCalculator.fractionDigits(of: inputString)
    }

    // MARK: Ввод

    public func addDigit(_ d: Int) {
        var s = inputString ?? ""

        if !hasPoint, input == 0 {
            // убираем ведущий ноль, сохраняя знак
            s = s.hasPrefix("-") ? "-" : ""
        } else if s.count >= inputLength || (hasPoint && fractionDigits >= maxFraction) {
            delegate?.calculatorDidInputOverflow(self)
            return
        }

        inputString = s + String(d)
        notifyInput()
    }

    public func addPoint() {
        if hasPoint { return }
        let s = inputString ?? "0"
        if s.count >= inputLength {
            delegate?.calculatorDidInputOverflow(self)
            return
        }
        inputString = s + "."
        notifyInput()
    }

    // MARK: Операции

    public func addOperation(_ op: Operation) {
        switch op {
        case .sign:
            if let s = inputString {
                inputString = s.hasPrefix("-") ? String(s.dropFirst()) : "-" + s
                notifyInput()
            } else if let r = result {
                setResult(-r)
            }

        case .perc:
            if let value = input {
                inputString = SimpleCalculator.string(from: value / 100, maxFraction: maxFraction)
                notifyInput()
            } else if let r = result {
                setResult(r / 100)
            }

        default:
            if input != nil {
                if operation != nil, result != nil {
                    compute()
                } else {
                    result = input
                    inputString = nil
                }
            } else if result == nil {
                result = 0
            }
            operation = op
        }
    }

    public func compute() {
        guard let op = operation, let left = result, let right = input else { return }

        let value: Double
        switch op {
        case .add: value = left + right
        case .sub: value = left - right
        case .mul: value = left * right
        case .div:
            if right == 0 {
                delegate?.calculatorDidNotCompute(self, withError: "Division by zero")
                return
            }
            value = left / right
        default:
            return
        }

        if !value.isFinite {
            delegate?.calculatorDidNotCompute(self, withError: "Result is too large")
            return
        }

        inputString = nil
        operation = nil
        setResult(value)
    }

    // MARK: Очистка

    public func clear() {
        inputString = nil
        delegate?.calculatorDidClear(self, withDefaultValue: result ?? 0,
                                     defaultPrecision: precision(of: result ?? 0))
    }

    public func reset() {
        result = nil
        operation = nil
        inputString = nil
        delegate?.calculatorDidClear(self, withDefaultValue: 0, defaultPrecision: 0)
    }

    // MARK: Вспомогательное

    private func notifyInput() {
        delegate?.calculatorDidUpdateValue(self, with: input ?? 0, valuePrecision: fractionDigits)
    }

    private func setResult(_ value: Double) {
        result = value
        delegate?.calculatorDidUpdateValue(self, with: value, valuePrecision: precision(of: value))
    }

    /// Количество значащих знаков после запятой (не больше maxFraction)
    private func precision(of value: Double) -> UInt {
        return SimpleCalculator.fractionDigits(of: SimpleCalculator.string(from: value, maxFraction: maxFraction))
    }

    private static func fractionDigits(of s: String?) -> UInt {
        guard let s = s, let point = s.firstIndex(of: ".") else { return 0 }
        return UInt(s.distance(from: point, to: s.endIndex) - 1)
    }

    /// Число в строку без лишних нулей в конце: 0.50000 -> "0.5", 2.000 -> "2"
    private static func string(from value: Double, maxFraction: UInt) -> String {
        var s = String(format: "%.\(maxFraction)f", value)
        if s.contains(".") {
            while s.hasSuffix("0") { s.removeLast() }
            if s.hasSuffix(".") { s.removeLast() }
        }
        return s
    }
}
