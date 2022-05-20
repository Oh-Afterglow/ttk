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
    @State var highestObjectHeight = 0.0
    var gameSceneNode = SCNNode()
    @Binding var affect: Bool
    

    
    func makeUIView(context: Context) -> ARSCNView {
        
        let gameSceneNodes = SCNScene(named: "art.scnassets/SceneKit Scene.scn")!.rootNode.childNodes
        for node in gameSceneNodes {
            gameSceneNode.addChildNode(node)
        }
        
        // add physics properties to the plate
        let plateNode = gameSceneNode.childNode(withName: "objectDropPlate", recursively: true)!
        let platePhysicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: plateNode, options: [.collisionMargin: 0.0]))
        platePhysicsBody.isAffectedByGravity = false
        platePhysicsBody.restitution = 0.0
        plateNode.physicsBody = platePhysicsBody
        
        // also add to the transparent lower plane, to let the objects fall to the table
        let planeNode = gameSceneNode.childNode(withName: "tablePlane", recursively: true)!
        let planePhysicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: planeNode, options: [.collisionMargin: 0.0]))
        planePhysicsBody.restitution = 0.0
        planePhysicsBody.isAffectedByGravity = false
        planeNode.physicsBody = planePhysicsBody
        
        
        return arSCNViewModel.arSCNView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if affect {
            
            let modelNode2 = gameSceneNode.childNode(withName: "A", recursively: true)!
            let physicsBodyReferenceShapeNode = gameSceneNode.childNode(withName: "ABoundCapsuleRefer", recursively: true)!
            let APhysicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: physicsBodyReferenceShapeNode, options: [.collisionMargin: 0.0]))
            APhysicsBody.restitution = 0.2
            APhysicsBody.angularVelocityFactor = SCNVector3(x: 0.2, y: 0.2, z: 0.2)
            modelNode2.physicsBody = APhysicsBody
            
            affect = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate {
        var parent: ARSCNViewContainer

        
        init(_ arSCNViewContainer: ARSCNViewContainer) {
            parent = arSCNViewContainer
            super.init()
            parent.arSCNViewModel.arSCNView.delegate = self
            enableTapGesture()
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
                }
            }
            
        }
    }
    
    
    
}



