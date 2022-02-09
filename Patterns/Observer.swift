import Foundation

// SOLUTION 1 - with protocols

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

// SOLUTION 2 - no protocols

class Newspaper {
    private var subscribers = NSMutableSet()
    var newPaper: String = "" {
        didSet {
            notify(about: newPaper)
        }
    }
    
    func add(_ subscriber: Subscriber) {
        subscribers.add(subscriber)
    }
    
    func remove(_ subscriber: Subscriber) {
        subscribers.remove(subscriber)
    }
    
    private func notify(about newPaper: String) {
        for sub in subscribers {
            (sub as! Subscriber).recieve(newPaper)
        }
    }
}

class Subscriber: NSObject {
    var myPaper: String = "Empty"
    
    func recieve(_ newPaper: String) {
        myPaper = newPaper
    }
}

let sub1 = Subscriber()
let sub2 = Subscriber()
let theTimes = Newspaper()

theTimes.add(sub1)
theTimes.newPaper = "The Navalny story"

sub1.myPaper // observer: "The Navalny story"
sub2.myPaper // not observer: "Empty"
