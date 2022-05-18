//
//  TitleScreen.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/19.
//

import SwiftUI

struct TitleScreen: View {
    
    @Binding var gameState: GameState
    
    var body: some View {
        VStack {
            Button(action: {
                gameState = .unstarted
            }, label: {
                Text("play!")
            })
        }
    }
}

//struct TitleScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        TitleScreen()
//    }
//}
