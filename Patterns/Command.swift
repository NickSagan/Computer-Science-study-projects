class BankAccount {
    var name: String
    var amount: Int
    
    init(name: String, amount: Int) {
        self.name = name
        self.amount = amount
    }
}

protocol Command {
    var completed: Bool { get set }
    func execute()
}

class Deposit: Command {
    
    private var _account: BankAccount
    private var _amount: Int
    var completed = false
    
    init(account: BankAccount, amount: Int){
        self._account = account
        self._amount = amount
    }
    
    func execute() {
        _account.amount += _amount
        completed = true
    }
}

class Withdraw: Command {
    
    private var _account: BankAccount
    private var _amount: Int
    var completed = false
    
    init(account: BankAccount, amount: Int){
        self._account = account
        self._amount = amount
    }
    
    func execute() {
        guard _account.amount >= _amount else {
            print("Not enough funds")
            return
        }
        _account.amount -= _amount
        completed = true
    }
}

class BankManager {
    static let shared = BankManager()
    private init() {}
    private var _commands: [Command] = []
    
    var pendingCommands: [Command] {
        get {
            return _commands.filter{!$0.completed}
        }
    }
    
    func addCommand(_ command: Command) {
        _commands.append(command)
    }
    
    func executeCommands() {
        _commands.filter{!$0.completed}.forEach{$0.execute()}
    }
}

let myAcc = BankAccount(name: "Nick Sagan", amount: 1000)
let bank = BankManager.shared

bank.addCommand(Deposit(account: myAcc, amount: 100))
myAcc.amount
bank.pendingCommands
bank.executeCommands()
myAcc.amount
bank.addCommand(Withdraw(account: myAcc, amount: 1000))
bank.addCommand(Deposit(account: myAcc, amount: 3000))
bank.pendingCommands
bank.executeCommands()
bank.pendingCommands
myAcc.amount
