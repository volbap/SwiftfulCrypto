//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 10/06/2024.
//

import Foundation

extension String {
    var removingHTMLOccurrences: String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
