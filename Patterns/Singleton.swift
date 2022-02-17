class CarStorage {
    var numberOfCars = 10
    static let shared = CarStorage()
    private init() {}
}

CarStorage.shared.numberOfCars += 1
CarStorage.shared.numberOfCars -= 3
