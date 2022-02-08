import Foundation

// strategy interface
protocol Operation {
    func calculate(_ a: Int, _ b: Int) -> Int
}

// strategy N1
class Multiply: Operation {
    func calculate(_ a: Int, _ b: Int) -> Int {
        return a * b
    }
}

// strategy N2
class Add: Operation {
    func calculate(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
}

// strategy N3
class Subtract: Operation {
    func calculate(_ a: Int, _ b: Int) -> Int {
        return a - b
    }
}

// strategies enum to set them easily
enum strategies {
    case multiply
    case add
    case subtract
}

// main class
class Calculator {
    
  // current strategy
    private var strategy: Operation
    
    init (strategy: Operation) {
        self.strategy = strategy
    }
    
  // set new strategy
    func setStrategy(_ strategies: strategies) {
        switch strategies {
        case .multiply: self.strategy = Multiply()
        case .add: self.strategy = Add()
        case .subtract: self.strategy = Subtract()
        }
    }
    
  // perform current strategy
    func performCalculation(_ a: Int, _ b: Int) -> Int {
        strategy.calculate(a, b)
    }
}

// demo
var myCalc = Calculator(strategy: Subtract())
myCalc.performCalculation(10, 5)
myCalc.setStrategy(.multiply)
myCalc.performCalculation(9, 9)
