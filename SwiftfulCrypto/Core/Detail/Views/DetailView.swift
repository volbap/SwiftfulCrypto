//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 06/06/2024.
//

import SwiftUI

struct DetailView: View {
    let coin: Coin

    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin: Mock.coin)
}
