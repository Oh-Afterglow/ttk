//
//  ContentView.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/18.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var arSCNViewModel = ARSCNViewModel()
    @StateObject var scoreRankViewModel = ScoreRankViewModel()
    @State var gameState = GameState.title
    
    
    var body: some View {
        if gameState == .title {
            titleScreen
        } else {
            gameScreen
        }

    }
    
    var titleScreen: some View {
        TitleScreen(gameState: self.$gameState, scoreRankViewModel: scoreRankViewModel)
    }
    
    var gameScreen: some View {
        GameScreen(arSCNViewModel: self.arSCNViewModel, scoreRankViewModel: scoreRankViewModel, gameState: self.$gameState)
            .ignoresSafeArea()
    }
}

enum GameState {
    case title, game
}
