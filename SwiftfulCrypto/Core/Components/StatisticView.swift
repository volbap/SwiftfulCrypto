//
//  StatisticView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 04/06/2024.
//

import SwiftUI

struct StatisticView: View {
    let statistic: Statistic

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees:
                            (statistic.percentageChange ?? 0) >= 0
                                ? 0
                                : 180
                        )
                    )
                Text(statistic.percentageChange?.toPercentage() ?? "")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(
                (statistic.percentageChange ?? 0) >= 0
                    ? Color.theme.green
                    : Color.theme.red
            )
            .opacity(statistic.percentageChange == nil ? 0 : 1)
        }
    }
}

#Preview {
    HStack(spacing: 32) {
        StatisticView(statistic: Mock.statistic1)
        StatisticView(statistic: Mock.statistic2)
        StatisticView(statistic: Mock.statistic3)
    }
}
