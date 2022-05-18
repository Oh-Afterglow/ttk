//
//  GameScreen.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/19.
//

import SwiftUI

struct GameScreen: View {
    
    @ObservedObject var arSCNViewModel: ARSCNViewModel
    @Binding var gameState: GameState
    @State var turn = Turn.first

    
    var body: some View {
        ZStack {
            ARSCNViewContainer(arSCNViewModel: arSCNViewModel, gameState: $gameState)
            
        }
    }
}

//struct GameScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        GameScreen()
//    }
//}

enum Turn {
    case first, second
}
