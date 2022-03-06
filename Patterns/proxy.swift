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
