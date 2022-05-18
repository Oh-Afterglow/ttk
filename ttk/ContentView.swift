//
//  ContentView.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/18.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var arSCNViewModel = ARSCNViewModel()
    @State var gameState = GameState.title
    
    
    var body: some View {
//        if gameState == .title {
//            TitleScreen(gameState: self.$gameState)
//        } else {
//            GameScreen(arSCNViewModel: self.arSCNViewModel, gameState: self.$gameState)
//        }
        GameScreen(arSCNViewModel: self.arSCNViewModel, gameState: self.$gameState)

    }
}

enum GameState {
    case title
    case unstarted, ongoing, ended
}
