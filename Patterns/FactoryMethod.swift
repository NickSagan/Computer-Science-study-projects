protocol Vehicle {
    func drive()
    func stop()
}

class Car: Vehicle {
    func stop() {
        print("Stop!")
    }
    
    func drive() {
        print("I'm driving a car")
    }
}
class Truck: Vehicle {
    func stop() {
        print("Stop!")
    }
    
    func drive() {
        print("I'm driving a truck")
    }
}
class Bus: Vehicle {
    func stop() {
        print("Stop!")
    }
    
    func drive() {
        print("I'm driving a bus")
    }
    
    func openDoors() {
        print("Doors are opened")
    }
    
    func closeDoors() {
        print("Doors are closed")
    }
}

protocol VehicleFactory {
    func produceVehicle() -> Vehicle
}

class CarFactory: VehicleFactory {
    func produceVehicle() -> Vehicle {
        print("Car is created")
        return Car()
    }
}
class TruckFactory: VehicleFactory {
    func produceVehicle() -> Vehicle {
        print("Truck is created")
        return Truck()
    }
}
class BusFactory: VehicleFactory {
    func produceVehicle() -> Vehicle {
        print("Bus is created")
        return Bus()
    }
}

let carFactory = CarFactory()
let myCar = carFactory.produceVehicle()
myCar.drive()

let truckFactory = TruckFactory()
let myTruck = truckFactory.produceVehicle()
myTruck.drive()

let busFactory = BusFactory()
let myBus = busFactory.produceVehicle()
myBus.drive()
myBus.stop()
(myBus as! Bus).openDoors()
(myBus as! Bus).closeDoors()
