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

    
    var body: some View {
        ZStack(alignment: .top) {
            ARSCNViewContainer(arSCNViewModel: arSCNViewModel, gameState: $gameState)
            
            if gameState == .ongoing {
                inGameLabel
            } else if gameState == .unstarted {
                prestartLabel
            } else if gameState == .ended {
                // nothing...
            }
        }
    }
    
    var prestartLabel: some View {
        VStack {
            Text("Tap on a plane to place the game scene.")
            Button(action: {
                gameState = .ongoing
            }, label: {
                Text("Start Game")
            })
        }
    }
    
    var inGameLabel: some View {
        VStack{
            HStack {
                Button(action: {
                    arSCNViewModel.translateObject(direction: .forward)
//                    print(arSCNViewModel.newModelNode.worldPosition)
//                    print(arSCNViewModel.newModelNode.position)
//                    print(arSCNViewModel.cameraDirection)
                }, label: {
                    Text("⬆️")
                })
                .buttonStyle(.bordered)
                Button(action: {
                    arSCNViewModel.translateObject(direction: .backward)
                }, label: {
                    Text("⬇️")
                })
                .buttonStyle(.bordered)
                Button(action: {
                    accumulatedObjectNumber += 1
                    arSCNViewModel.releaseNewModel()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        if gameState == .ongoing || gameState == .unstarted { // TODO: remove unstarted
                            arSCNViewModel.addNewModel()
                        }
                    }
                }, label: {
                   Text("place")
                })
                .buttonStyle(.bordered)
                Button(action: {
                    arSCNViewModel.translateObject(direction: .left)
                }, label: {
                    Text("⬅️")
                })
                .buttonStyle(.bordered)
                Button(action: {
                    arSCNViewModel.translateObject(direction: .right)
                }, label: {
                    Text("➡️")
                })
                .buttonStyle(.bordered)
            }
            HStack{
                Button(action: {
                    arSCNViewModel.rotateObject(direction: .x)
                }, label: {
                    Text("Rotate x")
                })
                .buttonStyle(.bordered)
                Button(action: {
                    arSCNViewModel.rotateObject(direction: .y)
                }, label: {
                    Text("Rotate y")
                })
                .buttonStyle(.bordered)
                Button(action: {
                    arSCNViewModel.rotateObject(direction: .z)
                }, label: {
                    Text("Rotate z")
                })
                .buttonStyle(.bordered)
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
