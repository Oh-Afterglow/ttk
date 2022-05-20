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
            Text("Try to pile up as many objects on the plate floating above your table as you can! Be careful to not let them fall on to your table!")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding(.vertical, 40)
                .padding(.horizontal, 45)

            Button(action: {
                gameState = .unstarted
            }, label: {
                Text("Play!")
                    .bold()
                    .padding()
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: 65)
                    .background(.blue)
                    .cornerRadius(15)
                    .foregroundColor(.white)
            })
        }
    }
}

//struct TitleScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        TitleScreen()
//    }
//}
