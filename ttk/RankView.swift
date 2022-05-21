//
//  RankView.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/22.
//

import SwiftUI
import CoreData


struct RankView: View {
    @FetchRequest(entity: ScoreRecord.entity(), sortDescriptors: [NSSortDescriptor(key: "score", ascending: false)])
    var records: FetchedResults<ScoreRecord>
    
    
    var body: some View {
        List {
            HStack {
                Text("Player")
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.45, alignment: .center)
                Text("Score")
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.45, alignment: .center)
            }
            ForEach(records) { record in
                HStack {
                    Text(record.username!)
                        .frame(width: UIScreen.main.bounds.width * 0.45, alignment: .center)
                    Text("\(record.score)")
                        .frame(width: UIScreen.main.bounds.width * 0.45, alignment: .center)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct RankView_Previews: PreviewProvider {
    static var previews: some View {
        RankView()
    }
}
