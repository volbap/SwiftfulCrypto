//
//  DetailLoadingView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 06/06/2024.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?

    var body: some View {
        if let coin = coin {
            DetailView(coin: coin)
        }
    }
}
