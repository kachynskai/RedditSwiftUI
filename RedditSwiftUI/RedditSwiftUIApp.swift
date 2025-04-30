//
//  RedditSwiftUIApp.swift
//  RedditSwiftUI
//
//  Created by Iryna on 22.04.2025.
//

import SwiftUI

@main
struct RedditSwiftUIApp: App {
    @StateObject private var navigation = NavigationManager()
    var body: some Scene {
        WindowGroup {
            TabView (selection: $navigation.selectedTab){
                PostListView()
                    .tabItem({
                        Label("Posts", systemImage: "chart.bar.horizontal.page")
                    })
                    .tag(0)
                CreatePostView()
                    .tabItem({
                        Label("Add", systemImage: "plus.circle")
                    })
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(2)
            }
            .accentColor(Color("MainColor"))
            .environmentObject(navigation)
        }
    }
}
