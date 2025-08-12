//
//  CardManager.swift
//  WeLink
//
//  Created by weonyee on 8/7/25.
//

import Foundation
import SwiftData

final class CardManager: ObservableObject {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func deleteCard(_ card: CardModel) {
        context.delete(card)
        do {
            try context.save()
        } catch {
            print("Failed to delete card: \(error)")
        }
    }
}
