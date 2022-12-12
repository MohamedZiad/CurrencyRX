//
//  HistoricalChartView.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 10/12/2022.
//

import SwiftUI
import Charts

struct HistoricalChartView: View {
    var transactionData: ChartModel
    var body: some View {
            ForEach(transactionData.data) { element in
                VStack {
                    Spacer()
                Chart{
                    BarMark(
                        x: .value("Rates", element.result),
                        y: .value("Date", element.date)
                    )
                }
            }
        }
    }
}
struct HistoricalChartView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricalChartView(transactionData: ChartModel(data: []))
    }
}
