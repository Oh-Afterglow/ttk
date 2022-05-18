//
//  ContentView.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/18.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var arSCNViewModel = ARSCNViewModel()
    @State var gameState = GameState.unstarted
    @State var turn = Turn.first
    
    
    var body: some View {
        ARSCNViewContainer(arSCNViewModel: arSCNViewModel, gameState: $gameState)
            
    }
}

enum GameState {
    case unstarted, ongoing, ended
}

enum Turn {
    case first, second
}
