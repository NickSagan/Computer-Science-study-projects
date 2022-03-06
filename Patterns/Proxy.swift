// Virtual proxy

class User {
    var name: String

    init(name: String) {
        self.name = name
    }
}

protocol ServerProtocol {
    func grantAccess(user: User)
    func denyAccess(user: User)
}

class ServerSide: ServerProtocol {
    
    func grantAccess(user: User) {
        print("Access granted to user: \(user.name)")
    }
    
    func denyAccess(user: User) {
        print("Access denied to user: \(user.name)")
    }
}

class ServerProxy: ServerProtocol {
    
    lazy private var server: ServerSide = ServerSide()
    
    func grantAccess(user: User) {
        server.grantAccess(user: user)
    }
    
    func denyAccess(user: User) {
        denyAccess(user: user)
    }
}

let user1 = User(name: "John")
let proxy = ServerProxy()
proxy.grantAccess(user: user1)
proxy.denyAccess(user: user1)

// Defence proxy

class User2 {
    var name: String
    var password: String

    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
}

protocol ServerProtocol2 {
    func grantAccess(user: User2)
}

class ServerSide2: ServerProtocol2 {
    
    func grantAccess(user: User2) {
        print("Access granted to user: \(user.name)")
    }
}

class ServerProxy2: ServerProtocol2 {
    
    private var server: ServerSide2!
    
    func grantAccess(user: User2) {
        guard server != nil else { print("Access denied"); return }
        server.grantAccess(user: user)
    }
    
    func authenticate(user: User2) {
        guard user.password == "qwerty" else { return }
        print("\(user.name) authenticated.")
        server = ServerSide2()
    }
}

let user2 = User2(name: "Harry", password: "qwe123")
let proxy2 = ServerProxy2()
proxy2.authenticate(user: user2)
proxy2.grantAccess(user: user2)
let user3 = User2(name: "Hermiona", password: "qwerty")
proxy2.grantAccess(user: user3)
proxy2.authenticate(user: user3)
proxy2.grantAccess(user: user3)
