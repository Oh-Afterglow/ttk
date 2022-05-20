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
    @State var scenePlaced = false
    @State var inGameButtonDisable = false

    
    var body: some View {
        ZStack(alignment: .top) {
            ARSCNViewContainer(arSCNViewModel: arSCNViewModel, gameState: $gameState, scenePlaced: $scenePlaced)
            
            VStack {
                Rectangle()
                    .frame(height: 30)
                    .opacity(0)
                
                if gameState == .ongoing {
                    inGameLabel
                } else if gameState == .unstarted {
                    prestartLabel
                } else if gameState == .ended {
                    // nothing...
                }
            }
        }
    }
    
    var prestartLabel: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(.thinMaterial)
                .frame(width: UIScreen.main.bounds.width * 0.85, height: 100, alignment: .center)
                
            VStack {
                Text("Tap on a plane to place the game scene.")
                    .bold()
                Button(action: {
                    gameState = .ongoing
                }, label: {
                    Text("Start Game")
                        .bold()
                        .disabled(!scenePlaced)
                })
                .buttonStyle(.bordered)
                
            }
        }
    }
    
    var inGameLabel: some View {
        VStack{
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thinMaterial)
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 120, alignment: .center)
                VStack {
                    HStack {
                        Button(action: {
                            arSCNViewModel.translateObject(direction: .forward)
                        }, label: {
                            Text("⬆️")
                        })
                            .buttonStyle(.bordered)
                            .disabled(inGameButtonDisable)
                        
                        Button(action: {
                            arSCNViewModel.translateObject(direction: .backward)
                        }, label: {
                            Text("⬇️")
                        })
                            .disabled(inGameButtonDisable)
                            .buttonStyle(.bordered)
                        
                        Button(action: {
                            accumulatedObjectNumber += 1
                            arSCNViewModel.releaseNewModel()
                            self.inGameButtonDisable = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                if gameState == .ongoing || gameState == .unstarted { // TODO: remove unstarted
                                    arSCNViewModel.updateHighestModelHeight()
                                    arSCNViewModel.addNewModel()
                                    self.inGameButtonDisable = false
                                }
                            }
                        }, label: {
                           Text("Place!")
                                .bold()
                                .foregroundColor(.white)
                        })
                            .disabled(inGameButtonDisable)
                            .tint(.indigo)
                            .buttonStyle(.borderedProminent)
                        
                        Button(action: {
                            arSCNViewModel.translateObject(direction: .left)
                        }, label: {
                            Text("⬅️")
                        })
                            .buttonStyle(.bordered)
                            .disabled(inGameButtonDisable)

                        Button(action: {
                            arSCNViewModel.translateObject(direction: .right)
                        }, label: {
                            Text("➡️")
                        })
                            .buttonStyle(.bordered)
                            .disabled(inGameButtonDisable)
                    
                    }
                    HStack{
                        Button(action: {
                            arSCNViewModel.rotateObject(direction: .x)
                        }, label: {
                            Text("Rotate X")
                                .foregroundColor(.indigo)
                        })
                            .buttonStyle(.bordered)
                            .disabled(inGameButtonDisable)

                        Button(action: {
                            arSCNViewModel.rotateObject(direction: .y)
                        }, label: {
                            Text("Rotate Y")
                                .foregroundColor(.indigo)
                        })
                            .buttonStyle(.bordered)
                            .disabled(inGameButtonDisable)

                        Button(action: {
                            arSCNViewModel.rotateObject(direction: .z)
                        }, label: {
                            Text("Rotate Z")
                                .foregroundColor(.indigo)
                        })
                            .buttonStyle(.bordered)
                            .disabled(inGameButtonDisable)
                    }
                        
                }
                
            }
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.thinMaterial)
                        .frame(width: 60, height: 60, alignment: .center)
                        .opacity(0.5)
                    Text("\(accumulatedObjectNumber)")
                        .font(.system(size: 20))
                        .bold()
                        .padding()
                }
                Rectangle()
                    .frame(maxWidth: .infinity, idealHeight: 60)
                    .opacity(0)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: 60)
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
