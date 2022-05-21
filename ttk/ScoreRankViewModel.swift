//
//  ScoreRankViewModel.swift
//  ttk
//
//  Created by todayis_afterglow on 2022/5/22.
//

import Foundation
import CoreData

class ScoreRankViewModel: ObservableObject {
    let container = NSPersistentContainer(name: "ScoreRankModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error)")
            }
        }
    }
    
    func insertNewRecord(score: Int16, playerName: String) {
        let context = container.viewContext
        let record = NSEntityDescription.insertNewObject(forEntityName: "ScoreRecord", into: context) as! ScoreRecord
        
        record.score = score
        record.username = playerName
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("\(error)")
            }
        }
    }
}
