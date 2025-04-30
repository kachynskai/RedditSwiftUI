//
//  SettingsView.swift
//  RedditSwiftUI
//
//  Created by Iryna on 22.04.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var settingVM = SettingsViewModel()
    @State private var initialAuthorName: String = ""
    var body: some View {
        VStack(spacing: 0){
            PageTitleView(title: "Settings")
            Form{
                Section("Author name:") {
                    TextField("Enter your name", text: $settingVM.authorName)
                }
            }
            ButtonView(
                buttonText: "Save",
                action:{
                    settingVM.saveName()
                    initialAuthorName = settingVM.authorName
                },
                isDisabled: settingVM.authorName.isEmpty || settingVM.authorName == initialAuthorName
            )
            .padding(10)
        }
        .padding(0)
        .onAppear{
            settingVM.loadName()
            initialAuthorName = settingVM.authorName
        }
        
    }
}

#Preview {
    SettingsView()
}
