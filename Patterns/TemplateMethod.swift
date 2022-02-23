// Basic class
class BuildHouse {
    
    // Template method
    final func startBuilding() {
        clearTheGround()
        layTheFoundation()
        deliverMaterials()
        assembleTheFrame()
        doorAndWindowInstallation()
    }
    
    func clearTheGround() {
        print("Ground is clear")
    }
    
    func layTheFoundation() {
        print("Foundation is ready")
    }
    
    // Abstract method
    func deliverMaterials() {
        preconditionFailure("Should be overriden")
    }
    
    // Abstract method
    func assembleTheFrame() {
        preconditionFailure("Should be overriden")
    }
    
    func doorAndWindowInstallation() {
        print("Doors and windows have been installed")
    }
}

class BuildWoodenHouse: BuildHouse {
    
    override func deliverMaterials() {
        print("Wooden materials arrived")
    }
    
    override func assembleTheFrame() {
        print("Wooden frame is assembled")
    }
}

class BuildStoneHouse: BuildHouse {
    
    override func deliverMaterials() {
        print("Stone materials arrived")
    }
    
    override func assembleTheFrame() {
        print("Stone frame is assembled")
    }
}

let woodBuilder = BuildWoodenHouse()
woodBuilder.startBuilding()
let stoneBuilder = BuildStoneHouse()
stoneBuilder.startBuilding()
