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
    var scene = SCNScene(named: "art.scnassets/SceneKit Scene.scn")
    
    init() {
        arSCNView = ARSCNView(frame: .zero)
        arSCNView.scene = self.scene!
        arSCNView.setupForARWorldConfiguration()
    }
}

extension ARSCNView{
    func setupForARWorldConfiguration(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.isAutoFocusEnabled = true
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        configuration.isLightEstimationEnabled = true
        self.session.run(configuration)
    }
}

