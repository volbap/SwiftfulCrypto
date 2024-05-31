//
//  Double.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import Foundation

extension Double {
    private func currencyFormatter(maxDecimals: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = maxDecimals
        formatter.usesGroupingSeparator = true
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        return formatter
    }

    /// Converts a double into a currency with 2 to `maxDecimals` decimal places.
    /// ```
    /// Example with 6 decimals:
    ///  Converts 1234.56 to "$ 1,234.56"
    ///  Converts 12.3456 to "$ 12.3456"
    ///  Converts 0.123456 to "$ 0.123456"
    /// ```
    func toCurrency(maxDecimals: Int = 2) -> String {
        currencyFormatter(maxDecimals: maxDecimals).string(for: self) ?? ""
    }

    /// Converts a double into a string representation.
    /// ```
    ///  Converts 1.23456 to "1.23"
    /// ```
    func toNumberString() -> String {
        String(format: "%.2f", self)
    }

    /// Converts a double into a string representation with percent symbol..
    /// ```
    ///  Converts 1.23456 to "1.23%"
    /// ```
    func toPercentage() -> String {
        toNumberString() + "%"
    }
}
