//
//  HomeStatisticsView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 04/06/2024.
//

import SwiftUI

struct HomeStatisticsView: View {
    @Binding var showPortfolio: Bool
    @EnvironmentObject private var viewModel: HomeViewModel

    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { statistic in
                StatisticView(statistic: statistic)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortfolio ? .trailing : .leading
        )
    }
}

#Preview {
    HomeStatisticsView(showPortfolio: .constant(false))
        .environmentObject(Mock.homeViewModel)
}
