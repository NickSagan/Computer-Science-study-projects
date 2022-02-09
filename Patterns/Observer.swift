import Foundation

protocol Observer {
    func notificationRecieved(_ message: String)
}

protocol Subject {
    func addObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
    func notify(_ message: String)
}

class Teacher: Subject {

    var observers = NSMutableSet()
    var homeTask: String = "" {
        didSet {
            notify(homeTask)
        }
    }

    func addObserver(_ observer: Observer) {
        observers.add(observer)
    }

    func removeObserver(_ observer: Observer) {
        observers.remove(observer)
    }

    func notify(_ message: String) {
        for obs in observers {
            (obs as! Observer).notificationRecieved(message)
        }
    }
}

class Pupil: NSObject, Observer {
    var homeTask: String = "Nothing"

    func notificationRecieved(_ message: String) {
        homeTask = message
    }
}

let pupil1 = Pupil()
let pupil2 = Pupil()
let teacher = Teacher()

teacher.addObserver(pupil1)

teacher.homeTask = "Math: page 127, ex.: 3...7"
pupil1.homeTask // observer: "Math: page 127, ex.: 3...7"
pupil2.homeTask // not observer: "Nothing"
