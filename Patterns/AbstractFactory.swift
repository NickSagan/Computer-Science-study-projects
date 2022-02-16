protocol Phone {
    func call()
}
protocol TV {
    func watch()
}
protocol Car {
    func drive()
}

class iPhone: Phone {
    func call() {
        print("I'm Iphone")
    }
}
class GooglePhone: Phone {
    func call() {
        print("I'm GooglePhone")
    }
}
class AppleTV: TV {
    func watch() {
        print("I'm watching Apple TV")
    }
}
class AndroidTV: TV {
    func watch() {
        print("I'm watching Google's Android TV")
    }
}
class GoogleCar: Car {
    func drive() {
        print("I'm driving Google Car")
    }
}
class AppleCar: Car {
    func drive() {
        print("I'm driving Apple Car")
    }
}

protocol Factory {
    func producePhone() -> Phone
    func produceTV() -> TV
    func produceCar() -> Car
}

class AppleFactory: Factory {
    func producePhone() -> Phone {
        print("I'm producing Apple Phone")
        return iPhone()
    }
    
    func produceTV() -> TV {
        print("I'm producing Apple TV")
        return AppleTV()
    }
    
    func produceCar() -> Car {
        print("I'm producing Apple Car")
        return AppleCar()
    }
    
    
}

class GoogleFactory: Factory {
    func producePhone() -> Phone {
        print("I'm producing Google Phone")
        return GooglePhone()
    }
    
    func produceTV() -> TV {
        print("I'm producing Google Android TV")
        return AndroidTV()
    }
    
    func produceCar() -> Car {
        print("I'm producing Google Car")
        return GoogleCar()
    }
}

let google = GoogleFactory()
let apple = AppleFactory()

let iPhone12 = apple.producePhone()
let googlePhone = google.producePhone()
let appCar = apple.produceCar()

let googCar = google.produceCar()
let appleTV = apple.produceTV()
let androiTV = google.produceTV()

iPhone12.call()
appCar.drive()
appleTV.watch()

googlePhone.call()
googCar.drive()
androiTV.watch()
