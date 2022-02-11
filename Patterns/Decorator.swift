import Foundation

protocol Porsche {
    func getPrice() -> Int
    func getDecription() -> String
}

// Concrete class
class Boxster: Porsche {
    func getPrice() -> Int {
        return 100
    }
    
    func getDecription() -> String {
        return "Porsche Boxster"
    }
}

// Concrete class #2
class Panamera: Porsche {
    func getPrice() -> Int {
        return 200
    }
    func getDecription() -> String {
        return "Porsche Panamera"
    }
}

// Abstract class for different decorations (options)
class PorscheDecorator: Porsche {
    
    private let decoratedPorsche: Porsche
    
    required init(dp: Porsche) {
        self.decoratedPorsche = dp
    }
    
    func getPrice() -> Int {
        return decoratedPorsche.getPrice()
    }
    
    func getDecription() -> String {
        return decoratedPorsche.getDecription()
    }
}

// Decoration class #1
class PremiumAudioSystem: PorscheDecorator {
    
    required init(dp: Porsche) {
        super.init(dp: dp)
    }
    
    override func getPrice() -> Int {
        super.getPrice() + 30
    }
    
    override func getDecription() -> String {
        super.getDecription() + " with premium audio system"
    }
}

// Decoration class #2
class PanoramicSunroof: PorscheDecorator {
    
    required init(dp: Porsche) {
        super.init(dp: dp)
    }
    
    override func getPrice() -> Int {
        super.getPrice() + 50
    }
    
    override func getDecription() -> String {
        super.getDecription() + " with panoramic roof"
    }
}

var porscheBoxster: Porsche = Boxster()
porscheBoxster.getDecription()
porscheBoxster.getPrice()

porscheBoxster = PremiumAudioSystem(dp: porscheBoxster)
porscheBoxster.getPrice()
porscheBoxster.getDecription()

porscheBoxster = PanoramicSunroof(dp: porscheBoxster)
porscheBoxster.getDecription()
porscheBoxster.getPrice()

var panamera007: Porsche = Panamera()
panamera007.getPrice()
panamera007.getDecription()

panamera007 = PanoramicSunroof(dp: panamera007)
panamera007.getDecription()
panamera007.getPrice()
