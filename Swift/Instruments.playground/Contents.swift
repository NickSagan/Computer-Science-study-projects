import Darwin
class Music {
  //This is a Music class that encapsulates an array of notes
  let notes: [String]

  init(notes: [String]) {
    self.notes = notes
  }

  func prepared() -> String {
      // returns String with separator " "
    return notes.joined(separator: " ")
  }
}


// Базовый класс, базовый чертеж Instrumenta. По сути это уже и есть encapsulation. -> Class types are said to encapsulate data (e.g. stored properties) and behavior (e.g. methods).
class Instrument {
  // Универсальное свойство которое будет у всех инструментов
  let brand: String
  // Initializer
  init(brand: String) {
    // Присваиваем входящий параметр brand
    self.brand = brand
  }
    // Abstract method!, must be overriden
    func tune() -> String {
      fatalError("Implement this method for \(brand)")
    }
    
    func play(_ music: Music) -> String {
      return music.prepared()
    }
    
    func perform(_ music: Music) {
      print(tune())
      print(play(music))
    }

}

// Piano subclass of Instrument parent class
class Piano: Instrument {
  let hasPedals: Bool
  // static propertiens (no dynamic changes)
  static let whiteKeys = 52
  static let blackKeys = 36
  
  // hasPedals have a default value, can be left off
  init(brand: String, hasPedals: Bool = false) {
    self.hasPedals = hasPedals
    // Request for parent's initializer
    super.init(brand: brand)
  }
  
  // Override parent's func. So now we can use it woth no fatal error
  override func tune() -> String {
    return "Piano standard tuning for \(brand)."
  }
  
    override func play(_ music: Music) -> String {
      return play(music, usingPedals: hasPedals)
    }

    
    func play(_ music: Music, usingPedals: Bool) -> String {
      let preparedNotes = super.play(music)
      if hasPedals && usingPedals {
        return "Play piano notes \(preparedNotes) with pedals."
      }
      else {
        return "Play piano notes \(preparedNotes) without pedals."
      }
    }

}

// instance of the Piano
let piano = Piano(brand: "Yamaha", hasPedals: true)
piano.tune()
// instance of the Music (можно вырать с педалями или нет)
let music = Music(notes: ["C", "G", "F"])
piano.play(music, usingPedals: false)
// Эта версия сама решает играть с педалями или нет в зависимости от их наличия
piano.play(music)
// No need for specific instance to call static properties
Piano.whiteKeys
Piano.blackKeys


// intermediate abstract base class.
class Guitar: Instrument {
  let stringGauge: String
  
    // переписываем инициализацию
  init(brand: String, stringGauge: String = "medium") {
    self.stringGauge = stringGauge
    // часть инициализации доелает родительский класс
    super.init(brand: brand)
  }
}

class AcousticGuitar: Guitar {
  static let numberOfStrings = 6
  static let fretCount = 20
  
  override func tune() -> String {
    return "Tune \(brand) acoustic with E A D G B E"
  }
  
  override func play(_ music: Music) -> String {
    let preparedNotes = super.play(music)
    return "Play folk tune on frets \(preparedNotes)."
  }
}

let acousticGuitar = AcousticGuitar(brand: "Roland", stringGauge: "Hard")
acousticGuitar.tune()
let guitarMusic = Music(notes: ["A", "B", "C"])
acousticGuitar.play(guitarMusic)

// This is also a root class, just like Instrument.
class Amplifier {
  // it can only be accessed inside of the Amplifier class and is hidden away from outside users
  private var _volume: Int
  // can be read by outside users but not written to
  private(set) var isOn: Bool

  init() {
    isOn = false
    _volume = 0
  }

  // That is how outside user can access isON property
  func plugIn() {
    isOn = true
  }
  func unplug() {
    isOn = false
  }

  // wraps the private stored property _volume.
  var volume: Int {
    // drops to zero if unplugged
    get {
      return isOn ? _volume : 0
    }
    // 0...10 constraint
    set {
      _volume = min(max(newValue, 0), 10)
    }
  }
}

// Concrete type. Not abstract
class ElectricGuitar: Guitar {
  // electric guitar contains an Amplifier
  let amplifier: Amplifier
  
  // Custom init + calls super.init
  init(brand: String, stringGauge: String = "light", amplifier: Amplifier) {
    self.amplifier = amplifier
    super.init(brand: brand, stringGauge: stringGauge)
  }

  override func tune() -> String {
    amplifier.plugIn()
    amplifier.volume = 5
    return "Tune \(brand) electric with E A D G B E"
  }
  
  override func play(_ music: Music) -> String {
    let preparedNotes = super.play(music)
    return "Play solo \(preparedNotes) at volume \(amplifier.volume)."
  }
}

class BassGuitar: Guitar {
  let amplifier: Amplifier

  init(brand: String, stringGauge: String = "heavy", amplifier: Amplifier) {
    self.amplifier = amplifier
    super.init(brand: brand, stringGauge: stringGauge)
  }

  override func tune() -> String {
    amplifier.plugIn()
    return "Tune \(brand) bass with E A D G"
  }

  override func play(_ music: Music) -> String {
    let preparedNotes = super.play(music)
    return "Play bass line \(preparedNotes) at volume \(amplifier.volume)."
  }
}

let amplifier555 = Amplifier()
amplifier555.plugIn()
amplifier555.volume = 8

let electricGuitar = ElectricGuitar(brand: "Gibson", stringGauge: "Medium", amplifier: amplifier555)
let bassGuitar = BassGuitar(brand: "Fender", stringGauge: "Light", amplifier: amplifier555)

electricGuitar.tune()
bassGuitar.tune()

// Guitars sharing 1 amplifier
bassGuitar.amplifier.volume = 10
print(bassGuitar.amplifier.volume)
electricGuitar.amplifier.volume = 6
print(bassGuitar.amplifier.volume)
electricGuitar.amplifier.unplug()
print(bassGuitar.amplifier.volume)

// Polymorphism in action. Different objects but 1 interface
class Band {
  let instruments: [Instrument]
  
  init(instruments: [Instrument]) {
    self.instruments = instruments
  }
  
  func perform(_ music: Music) {
    for instrument in instruments {
      instrument.perform(music)
    }
  }
}


// Although the instruments array’s type is [Instrument], each instrument performs depending on its class type. This is how polymorphism works in practice

let instruments = [piano, acousticGuitar, electricGuitar, bassGuitar]
let band = Band(instruments: instruments)
print(band.perform(music))



//ACCESS CONTROL
//private: Visible just within the class.
//fileprivate: Visible from anywhere in the same file.
//internal: Visible from anywhere in the same module or app.
//public: Visible anywhere outside the module.
