//
//  ContentView.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/18.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var arSCNViewModel = ARSCNViewModel()
    
    var body: some View {
        ARSCNViewContainer(arSCNViewModel: arSCNViewModel)
            
    }
}
