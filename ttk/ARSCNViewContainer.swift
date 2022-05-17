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
    
    
    func makeUIView(context: Context) -> ARSCNView {
        arSCNViewModel.arSCNView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARSCNViewContainer
        
        init(_ arSCNViewContainer: ARSCNViewContainer) {
            parent = arSCNViewContainer
            super.init()
            parent.arSCNViewModel.arSCNView.delegate = self
        }
    }
}
