 
protocol Coworker {
    func hire(_ coworker: Coworker)
    func getInfo()
    var lvl: Int { get }
}

// Branch
class Manager: Coworker {

    private var coworkers = [Coworker]()
    var lvl: Int
    
    init(lvl: Int) {
        self.lvl = lvl
    }

    func hire(_ coworker: Coworker) {
        self.coworkers.append(coworker)
    }
    
    func getInfo() {
        print("Manager level: \(lvl)")
        for coworker in coworkers {
            coworker.getInfo()
        }
    }
}

// Leaf
class LowLevelManager: Coworker {
    var lvl: Int
    
    init(lvl: Int) {
        self.lvl = lvl
    }

    func hire(_ coworker: Coworker) {
        print("Can't hire")
    }
    
    func getInfo() {
        print("Manager level: \(lvl)")
    }
}

let topMng = Manager(lvl: 1)
let mng2 = Manager(lvl: 2)
let mng3_1 = Manager(lvl: 3)
let mng3_2 = Manager(lvl: 3)
let mng3_3 = Manager(lvl: 3)
let mng5 = LowLevelManager(lvl: 5)

topMng.hire(mng2)
mng2.hire(mng3_1)
mng2.hire(mng3_2)
mng2.hire(mng3_3)
mng3_2.hire(mng5)

topMng.getInfo()
