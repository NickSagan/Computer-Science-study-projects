// Adaptee
class Car {
    var price = 700

    func getPrice() -> String {
        print("Price is \(price) RUB")
        return "Price is \(price) RUB"
    }
}

// Target
protocol InternationalCar {
    func getPriceInUSD() -> String
}

class NewCar: InternationalCar {
    var price = 15

    func getPriceInUSD() -> String {
        print("Price is \(price) USD")
        return "Price is \(price) USD"
    }
}

// Adapter
class InternationalCarAdapter: InternationalCar {
    var car: Car
    var usdPrice = 75

    init(car: Car) {
        self.car = car
    }

    func getPriceInUSD() -> String {
        print("Price is \(car.price / usdPrice) USD")
        return "Price is \(car.price / usdPrice) USD"
    }
}

var myCar = Car()
myCar.getPrice()
var myInternationalCar = InternationalCarAdapter(car: myCar)
myInternationalCar.getPriceInUSD()
