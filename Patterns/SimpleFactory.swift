
protocol Car {
    func drive()
}

class BigCar: Car {
    
    var name: String
    
    func drive(){
    print("You are driving a BIG car")
    }
    
    init (name: String) {
        self.name = name
    }
}

class FastCar: Car {
    func drive(){
    print("You are driving a FAST car")
    }
}

class CarFactory {
    enum CarType {
        case fast, big
    }
    
    static func produceCar(type: CarType) -> Car {
        var car: Car
        
        switch type{
        case .fast: car = FastCar()
        case .big: car = BigCar(name: "007")
        }
        
        return car
    }
}

let porsche = CarFactory.produceCar(type: .fast)
let truck = CarFactory.produceCar(type: .big)
