//
//  ARSCNViewContainer.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/18.
//

import SwiftUI
import ARKit
import SceneKit

struct ARSCNViewContainer: UIViewRepresentable {
    
    @ObservedObject var arSCNViewModel: ARSCNViewModel
    @Binding var gameState: GameState
    @Binding var scenePlaced: Bool
    var gameSceneNode = SCNNode()
    
    func makeUIView(context: Context) -> ARSCNView {
        gameSceneNode.name = "gameScene"
        
        let gameSceneNodes = SCNScene(named: "art.scnassets/SceneKit Scene.scn")!.rootNode.childNodes
        for node in gameSceneNodes {
            gameSceneNode.addChildNode(node)
        }
        
        arSCNViewModel.newModelNode.name = "newModel"
        gameSceneNode.addChildNode(arSCNViewModel.newModelNode)
        arSCNViewModel.addNewModel()
        
        // add physics properties to the plate
        let plateNode = gameSceneNode.childNode(withName: "objectDropPlate", recursively: true)!
        let platePhysicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: plateNode, options: [.collisionMargin: 0.0]))
        platePhysicsBody.isAffectedByGravity = false
        platePhysicsBody.restitution = 0.0
        platePhysicsBody.friction = 1.0  // make it more unable to slide
        platePhysicsBody.rollingFriction = 0.95
        platePhysicsBody.categoryBitMask ^= 1
//        print(platePhysicsBody.categoryBitMask)
        plateNode.physicsBody = platePhysicsBody
        
        // also add to the transparent lower plane, to let the objects fall to the table
        let planeNode = gameSceneNode.childNode(withName: "tablePlane", recursively: true)!
        let planePhysicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: planeNode, options: [.collisionMargin: 0.0]))
        planePhysicsBody.restitution = 0.0
        planePhysicsBody.isAffectedByGravity = false
        planePhysicsBody.categoryBitMask = 1  // only report contact with table plane
//        print(planePhysicsBody.categoryBitMask)
        planeNode.physicsBody = planePhysicsBody
        
        
        return arSCNViewModel.arSCNView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate {
        var parent: ARSCNViewContainer
        var frameCounter = 0

        
        init(_ arSCNViewContainer: ARSCNViewContainer) {
            parent = arSCNViewContainer
            super.init()
            
            // correspond with the 3 delegate base class respectively
            parent.arSCNViewModel.arSCNView.delegate = self
            parent.arSCNViewModel.arSCNView.session.delegate = self
            parent.arSCNViewModel.arSCNView.scene.physicsWorld.contactDelegate = self
            
            enableTapGesture()
        }
        
        func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
            if contact.nodeA.name == "tablePlane" || contact.nodeB.name == "tablePlane" {
                // when an object falls off the ground, the game stops
                parent.gameState = .ended
                
            }
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            if frameCounter % 2 == 0 {
                // update the direction of camera 30 times a second
                
                let cameraMat = SCNMatrix4(frame.camera.transform)
//                let origin = parent.arSCNViewModel.newModelNode.position
                parent.arSCNViewModel.cameraDirection = SCNVector3(x: -1 * cameraMat.m31, y: -1 * cameraMat.m32, z: -1 * cameraMat.m33)
            }
            frameCounter += 1
        }
        
        func enableTapGesture() {
            let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer: )))
            self.parent.arSCNViewModel.arSCNView.addGestureRecognizer(tapGestureRecongnizer)
        }
        
        @objc func handleTap(recognizer: UITapGestureRecognizer){
            if parent.gameState == .unstarted {  // only allow adjusting position before the game start
                let tapLocation = recognizer.location(in: self.parent.arSCNViewModel.arSCNView)
                let hitTest = self.parent.arSCNViewModel.arSCNView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
                if hitTest.isEmpty {  // TODO: If I have enough time, change this into raycast
                    print("no plane")
                    return
                } else {
                    let columns = hitTest.first!.worldTransform.columns.3
                    parent.gameSceneNode.position = SCNVector3Make(columns.x, columns.y, columns.z)
                    self.parent.arSCNViewModel.arSCNView.scene.rootNode.addChildNode(parent.gameSceneNode)
                    parent.scenePlaced = true
                }
            }
        }
    }
}
