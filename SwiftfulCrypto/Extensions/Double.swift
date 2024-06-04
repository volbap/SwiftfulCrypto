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

    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.toNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.toNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.toNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.toNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return toNumberString()

        default:
            return "\(sign)\(self)"
        }
    }
}
