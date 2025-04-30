//
//  NavigationManager.swift
//  RedditSwiftUI
//
//  Created by Iryna on 29.04.2025.
//

import SwiftUI
@MainActor 
final class NavigationManager: ObservableObject{
    @Published var selectedTab: Int = 0

    func goToPosts() { selectedTab = 0 }
    func goToCreatePost() { selectedTab = 1 }
    func goToSettings() { selectedTab = 2 }
}
