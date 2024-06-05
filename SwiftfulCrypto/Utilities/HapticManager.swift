//
//  HapticManager.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 05/06/2024.
//

import SwiftUI

class HapticManager {
    static let shared = HapticManager()

    private init() {}

    private let generator = UINotificationFeedbackGenerator()

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
