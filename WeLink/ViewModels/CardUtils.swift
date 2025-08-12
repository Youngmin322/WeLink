//
//  CardUtils.swift
//  WeLink
//
//  Created by 조영민 on 8/11/25.
//

import SwiftUI

// MARK: - Card Array Extensions
extension Array where Element == CardModel {
    func safeIndex(_ index: Int) -> Int {
        guard !isEmpty else { return 0 }
        let clampedIndex = index < 0 ? 0 : (index >= count ? count - 1 : index)
        return clampedIndex
    }
}

// MARK: - Animation Constants
struct AnimationConstants {
    static let cardTransition = Animation.easeInOut(duration: 0.3)
    static let indexChange = Animation.easeInOut(duration: 0.2)
    static let dragResponse = Animation.spring(response: 0.8, dampingFraction: 0.7)
    static let deleteButton = Animation.spring(response: 0.5, dampingFraction: 0.8)
}
