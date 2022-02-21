class Manager {

    func acceptOrder() {
        print("Your order has been accepted by the manager.")
    }
}

class Assembler {

    func assemble() {
        print("Your order has been assembled.")
    }
}

class Packing {

    func pack() {
        print("Your order has been packed.")
    }
}

class Delivery {

    func deliver() {
        print("Your order has been delivered.")
    }
}

// Facade

class InternetShop {
    private let manager = Manager()
    private let assembler = Assembler()
    private let packing = Packing()
    private let delivery = Delivery()

    func makeOrder() -> String {
        manager.acceptOrder()
        assembler.assemble()
        packing.pack()
        delivery.deliver()
        print("Order processed.")
        return "Thanks for your order"
    }
}

let myShop = InternetShop()
myShop.makeOrder()
