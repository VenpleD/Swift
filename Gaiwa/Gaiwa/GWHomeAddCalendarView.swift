//
//  GWHomeAddCalendarView.swift
//  Gaiwa
//
//  Created by duanwenpu on 2022/3/3.
//

import SwiftUI

struct GWScrollView: UIViewRepresentable {
    @Binding var pagingEnabled: Bool
    func makeUIView(context: Context) -> some UIView {
        let scrollView = UIScrollView.init()
        scrollView.isPagingEnabled = pagingEnabled
        return scrollView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct GWHomeAddCalendarView: View {
    @State private var viewModel: GWHomeAddCalendarViewModel = GWHomeAddCalendarViewModel.init()
    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            TabView {
                let currentDayOfMonthData:[GWMonthModel] = self.viewModel.loadRecentSevenMonthOfCurrentDay(currentDay: Date())
                ForEach(0..<currentDayOfMonthData.count, id:\.self) { index in
                    let mothModel: GWMonthModel = currentDayOfMonthData[index]
                    Text("\(mothModel.dateMonth)")
                }
            }
            .tabViewStyle(PageTabViewStyle.page)
        }


//        GWScrollView() {
//            LazyHStack(alignment: .top, spacing: 10) {
//                ForEach(1...100, id: \.self) {
//                    Text("Column \($0)")
//                        .fixedSize()
//                }
//                .background(.yellow)
//            }
//            let array = self.viewModel.loadRecentSevenMonthOfCurrentDay(currentDay: Date())
//            ForEach(0..<array.count, id:\.self) {
//                let monthModel: GWMonthModel = array[$0]
//
//            }
//        }

    }
}
