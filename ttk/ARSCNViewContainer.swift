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

    
    func makeUIView(context: Context) -> ARSCNView {
        return arSCNViewModel.arSCNView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        var parent: ARSCNViewContainer

        
        init(_ arSCNViewContainer: ARSCNViewContainer) {
            parent = arSCNViewContainer
            super.init()
            parent.arSCNViewModel.arSCNView.delegate = self
            enableTapGesture()
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, nodeFor anchor: ARAnchor) {
            
        }
        
        func enableTapGesture() {
            let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer: )))
            self.parent.arSCNViewModel.arSCNView.addGestureRecognizer(tapGestureRecongnizer)
        }
        
        @objc func handleTap(recognizer: UITapGestureRecognizer){
            let tapLocation = recognizer.location(in: self.parent.arSCNViewModel.arSCNView)
            let hitTest = self.parent.arSCNViewModel.arSCNView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
            if hitTest.isEmpty {
                print("no plane")
                return
            } else {
                let columns = hitTest.first!.worldTransform.columns.3
                parent.gameSceneNode.position = SCNVector3Make(columns.x, columns.y, columns.z)
                let gameSceneNodes = SCNScene(named: "art.scnassets/SceneKit Scene.scn")!.rootNode.childNodes
                for node in gameSceneNodes {
                    parent.gameSceneNode.addChildNode(node)
                }
                self.parent.arSCNViewModel.arSCNView.scene.rootNode.addChildNode(parent.gameSceneNode)
            }
            
        }
    }
    
    
    
}



