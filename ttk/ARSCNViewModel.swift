//
//  ARSCNViewModel.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/18.
//

import SwiftUI
import ARKit
import SceneKit

class ARSCNViewModel: ObservableObject {
    var arSCNView: ARSCNView
    var currentNode: SCNNode?
    var cameraDirection = SCNVector3()
    var newModelNode = SCNNode() // a special node to place the newly added object
    var counter = 0
    
    init() {
        arSCNView = ARSCNView(frame: .zero)
        arSCNView.scene = SCNScene()
        arSCNView.scene.physicsWorld.gravity.y = -1.0
        newModelNode.position.y += 0.3
        newModelNode.name = "newModel"
        arSCNView.setupForARWorldConfiguration()
    }
    
    func addNewModel() {
        if newModelNode.name != "newModel" {  // create the new model node
            newModelNode = SCNNode()
            newModelNode.name = "newModel"
            newModelNode.position.y += 0.3
            let gameSceneNode = arSCNView.scene.rootNode.childNode(withName: "gameScene", recursively: true)!
            gameSceneNode.addChildNode(newModelNode)
        }
        
        // TODO: randomly choose a new model...
        let modelNodes = SCNScene(named: "art.scnassets/A.scn")!.rootNode.childNodes
        for node in modelNodes {
            newModelNode.addChildNode(node)
        }
    }
    
    func releaseNewModel() {
        let modelNode = newModelNode.childNodes.first! // The model node is before the physics shape node in the scene
        
        let APhysicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: newModelNode.childNodes[1], options: [.collisionMargin: 0.0]))
        APhysicsBody.restitution = 0.2
        APhysicsBody.angularVelocityFactor = SCNVector3(x: 0.2, y: 0.2, z: 0.2)
        APhysicsBody.categoryBitMask = 1   // 1 is for the new model
        modelNode.physicsBody = APhysicsBody
        
        newModelNode.name = "model\(counter)"
        counter += 1
    }
    
    func translateObject(direction: TranslateDirection) {
        // I'm really bad at computer graphics.
        //This reminds me of the course in the last semester for which I got the worst grade among all courses.
        
        let directionAngle: Float
        if direction == .left || direction == .right { // move in a vertical direction to the camera direction
            directionAngle = atan(cameraDirection.x / cameraDirection.z)
        } else {  // move in a parallel direction to the camera direction
            directionAngle = atan(-cameraDirection.z / cameraDirection.x)
        }

        // move 0.5cm
        var deltaX = 0.005 * cosf(directionAngle)
        var deltaZ = 0.005 * sinf(directionAngle)

        if direction == .backward || direction == .left {
            deltaX = -deltaX
            deltaZ = -deltaZ
        }

        // move the node and limit it in the field
        if newModelNode.position.x + deltaX > 0.075 {
            newModelNode.position.x = 0.075
        } else if newModelNode.position.x + deltaX < -0.075 {
            newModelNode.position.x = -0.075
        } else {
            newModelNode.position.x += deltaX
        }

        if newModelNode.position.z + deltaZ > 0.075 {
            newModelNode.position.z = 0.075
        } else if newModelNode.position.z + deltaZ < -0.075 {
            newModelNode.position.z = -0.075
        } else {
            newModelNode.position.z += deltaZ
        }
        
    }
    
    func rotateObject() {
        
    }
    
}

extension ARSCNView {
    func setupForARWorldConfiguration(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.isAutoFocusEnabled = true
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        configuration.isLightEstimationEnabled = true
        self.session.run(configuration)
    }
}

enum TranslateDirection {
    case forward, backward, left, right
    // will adjust direction according to camera direction
}

enum RotateDirection {
    case x, y, z
    // in the local coordinates of the object, and will not adjust direction according to the camera direction
}
