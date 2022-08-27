//
//  GWHomeAddView.swift
//  Gaiwa
//
//  Created by duanwenpu on 2022/3/3.
//

import SwiftUI

struct GWHomeAddView: View {
    @Binding public var tabSelectIndex: Int
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                GWHomeAddCalendarView()
                    .background(.red)
                Text("hello add")
                    .background(.green)
            }
            .navigationBarHidden(true)
        }
        .onTapGesture {
            self.tabSelectIndex = 3
        }
        .tabItem {
            Image(systemName: "plus.rectangle")
        }.tag(3)
    }
}
