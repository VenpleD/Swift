//
//  GWHomeTabView.swift
//  Gaiwa
//
//  Created by duanwenpu on 2022/3/2.
//

import SwiftUI

struct GWHomeTabView: View {
    @State private var tabSelectIndex = 3
    var body: some View {
        TabView(selection: $tabSelectIndex) {
            NavigationView {

            }
            .onTapGesture {
                self.tabSelectIndex = 1
            }
            .tabItem {
                Image(systemName: "photo")
            }.tag(1)

            NavigationView {

            }
            .onTapGesture {
                self.tabSelectIndex = 2
            }
            .tabItem {
                Image(systemName: "photo")
            }.tag(2)
            GWHomeAddView(tabSelectIndex: self.$tabSelectIndex)
            NavigationView {

            }
            .onTapGesture {
                self.tabSelectIndex = 4
            }
            .tabItem {
                Image(systemName: "photo")
            }.tag(4)
            NavigationView {

            }
            .onTapGesture {
                self.tabSelectIndex = 5
            }
            .tabItem {
                Image(systemName: "photo")
            }.tag(5)
        }
    }
}
