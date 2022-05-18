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
    @State var tapped = false
    @State var tappedPosition = CGPoint(x: 0, y: 0)
    
    
    func makeUIView(context: Context) -> ARSCNView {
        return arSCNViewModel.arSCNView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, $tapped, $tappedPosition)
    }
    
    final class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        var parent: ARSCNViewContainer
        @Binding var tapped: Bool
        @Binding var tappedLocation: CGPoint
        
        init(_ arSCNViewContainer: ARSCNViewContainer, _ tapped: Binding<Bool>, _ location: Binding<CGPoint>) {
            parent = arSCNViewContainer
            self._tapped = tapped
            self._tappedLocation = location
            super.init()
            parent.arSCNViewModel.arSCNView.delegate = self
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, nodeFor anchor: ARAnchor) {
            
        }
        
        
    }
    
}



