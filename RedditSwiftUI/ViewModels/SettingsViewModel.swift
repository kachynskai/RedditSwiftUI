//
//  SettingsViewModel.swift
//  RedditSwiftUI
//
//  Created by Iryna on 22.04.2025.
//

import Foundation
@MainActor 
final class SettingsViewModel: ObservableObject{
    @Published var authorName = ""
    
    private let authorNameKey = "AuthorName"
    
    init(){
        loadName()
    }
    
    func loadName(){
        if let name = UserDefaults.standard.string(forKey: authorNameKey){
            self.authorName = name
        }
    }
    func saveName(){
        UserDefaults.standard.set(authorName, forKey: authorNameKey)
    }
}
