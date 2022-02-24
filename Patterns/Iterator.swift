class Driver {
    let name: String
    let isGoodDriver: Bool
    
    init(name: String, isGoodDriver: Bool) {
        self.name = name
        self.isGoodDriver = isGoodDriver
    }
}

class Car {
    var goodDriverIterator: GoodDriverIterator {
        return GoodDriverIterator(drivers: drivers)
    }
    private var drivers = [
        Driver(name: "Petr", isGoodDriver: true),
        Driver(name: "Ivan", isGoodDriver: false),
        Driver(name: "Oleg", isGoodDriver: true),
        Driver(name: "Anna", isGoodDriver: true)
    ]
}

extension Car: Sequence {
    func makeIterator() -> GoodDriverIterator {
        return GoodDriverIterator(drivers: drivers)
    }
}

class GoodDriverIterator: IteratorProtocol {
    
    private let drivers: [Driver]
    private var current = 0
    
    init(drivers: [Driver]){
        self.drivers = drivers.filter{ $0.isGoodDriver }
    }
    
    func next() -> Driver? {
        defer { current += 1 }
        return drivers.count > current ? drivers[current] : nil
    }
}

let myCar = Car()
let iterator = myCar.makeIterator()
print(iterator.next()?.name as Any)
for driver in myCar {
    print(driver.name)
}
