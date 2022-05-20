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
    @State var accumulatedObjectNumber = 0
    @State var affect = false

    
    var body: some View {
        ZStack(alignment: .top) {
            ARSCNViewContainer(arSCNViewModel: arSCNViewModel, gameState: $gameState, affect: $affect)
            Button(action: {
                affect = true
            }, label: {
               Text("affect")
            })
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
