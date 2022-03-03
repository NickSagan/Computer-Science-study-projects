protocol State {
    func on(printer: Printer)
    func off(printer: Printer)
    func printDocument(printer: Printer)
}

class On: State {
    
    func on(printer: Printer) {
        print("Printer is already on")
    }
    
    func off(printer: Printer) {
        printer.setState(state: Off())
        print("Printer is off now")
    }
    
    func printDocument(printer: Printer) {
        print("Printing...")
    }
}

class Off: State {
    
    func on(printer: Printer) {
        printer.setState(state: On())
        print("Printer is on now")
    }
    
    func off(printer: Printer) {
        print("Printer is already off")
    }
    
    func printDocument(printer: Printer) {
        print("Printer is off. Can't print.")
    }
}

class Print: State {
    
    func on(printer: Printer) {
        print("Printer is already on")
    }
    
    func off(printer: Printer) {
        printer.setState(state: Off())
        print("Printer is off now")
    }
    
    func printDocument(printer: Printer) {
        print("Printer is already printing")
    }
}

class Printer {
    var state: State
    
    init() {
        self.state = Off()
    }
    
    func setState(state: State){
        self.state = state
    }
    
    func setOn() {
        state.on(printer: self)
    }
    
    func setOff() {
        state.off(printer: self)
    }
    
    func printDocument() {
        state.printDocument(printer: self)
    }
}

let myPrinter = Printer()
myPrinter.setOn()
myPrinter.printDocument()
myPrinter.setOff()
myPrinter.printDocument()
