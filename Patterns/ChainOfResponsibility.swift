// Chain of responsibility

class Dragon {
    let power: Int
    
    init(power: Int){
        self.power = power
    }
}

protocol WarriorChain {
    var strength: Int { get set }
    var nextWarrior: WarriorChain? { get set }
    func defeatTheDragon(with power: Int)
}

class LittleHero: WarriorChain {
    var strength: Int = 300
    var nextWarrior: WarriorChain?
    
    func defeatTheDragon(with power: Int) {
        if strength > power {
            print("Little hero defeated the dragon")
        } else {
            nextWarrior?.defeatTheDragon(with: power)
        }
    }
}

class Witcher: WarriorChain {
    var strength: Int = 600
    var nextWarrior: WarriorChain?
    
    func defeatTheDragon(with power: Int) {
        if strength > power {
            print("Witcher defeated the dragon")
        } else {
            nextWarrior?.defeatTheDragon(with: power)
        }
    }
}

class DragonBorn: WarriorChain {
    var strength: Int = 1500
    var nextWarrior: WarriorChain?
    
    func defeatTheDragon(with power: Int) {
        if strength > power {
            print("DragonBorn defeated the dragon")
        } else {
            print("This dragon is invincible")
        }
    }
}

let wizerion = Dragon(power: 200)
let okwist = Dragon(power: 500)
let alduin = Dragon(power: 1100)
let parturnaks = Dragon(power: 2000)
let peasant = LittleHero()
let heralt = Witcher()
let dovakin = DragonBorn()
peasant.nextWarrior = heralt
heralt.nextWarrior = dovakin

peasant.defeatTheDragon(with: wizerion.power)
peasant.defeatTheDragon(with: okwist.power)
peasant.defeatTheDragon(with: alduin.power)
peasant.defeatTheDragon(with: parturnaks.power)
