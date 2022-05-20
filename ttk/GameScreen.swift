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
    @State var placeObject = false

    
    var body: some View {
        ZStack(alignment: .top) {
            ARSCNViewContainer(arSCNViewModel: arSCNViewModel, gameState: $gameState, affect: $placeObject, accumulatedObjectNumber: $accumulatedObjectNumber)
            if gameState == .ongoing {
                HStack {
                    Button(action: {
                        arSCNViewModel.translateObject(direction: .forward)
                    }, label: {
                        Text("⬆️")
                    })
                    Button(action: {
                        arSCNViewModel.translateObject(direction: .backward)
                    }, label: {
                        Text("⬇️")
                    })
                    Button(action: {
                        accumulatedObjectNumber += 1
                        arSCNViewModel.releaseNewModel()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if gameState == .ongoing || gameState == .unstarted { // TODO: remove unstarted
                                arSCNViewModel.addNewModel()
                            }
                        }
                    }, label: {
                       Text("place")
                    })
                    Button(action: {
                        arSCNViewModel.translateObject(direction: .left)
                    }, label: {
                        Text("⬅️")
                    })
                    Button(action: {
                        arSCNViewModel.translateObject(direction: .right)
                    }, label: {
                        Text("➡️")
                    })
                }
            } else if gameState == .unstarted {  
                Button(action: {
                    gameState = .ongoing
                }, label: {
                    Text("Start Game")
                })
            }
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
