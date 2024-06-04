//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 04/06/2024.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
