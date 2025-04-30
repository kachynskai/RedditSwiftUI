//
//  CreatePostViewModel.swift
//  RedditSwiftUI
//
//  Created by Iryna on 22.04.2025.
//

import SwiftUI
import PhotosUI
@MainActor 
final class CreatePostViewModel: ObservableObject{
    @Published var title: String = ""
    @Published var text: String = ""
    @Published var author: String = ""
    @Published var selectedImage: Image?
    @Published var selectedImageData: Data?
    @Published var showSettingsAlert = false
    
    private let settingVM = SettingsViewModel()
    private let postManager = SavedPostManager.shared
    private let imageManager = ImageManager.shared
    
    func loadAuthoreName(){
        settingVM.loadName()
        self.author = settingVM.authorName
        
        self.showSettingsAlert = self.author.isEmpty
    }
    func removeSelectedPhoto() {
        self.selectedImage = nil
        self.selectedImageData = nil
        print("removed photo")
    }
    
    func resetForm(){
        self.title = ""
        self.text = ""
        self.selectedImage = nil
        self.selectedImageData = nil
        self.showSettingsAlert = false
    }
    func savePost() async {
        print("Saving post...")
        var localImagePath: String? = nil
        let postId = UUID().uuidString
        if let imageData = selectedImageData {
            localImagePath = await imageManager.saveImg(imageData, for: postId)
            if localImagePath != nil {
                print("Image saved, path: \(localImagePath!)")
            } else {
                print("Failed to save image synchronously.")
                return
            }
        } else {
            print("No image data to save.")
        }
        let newPost = Post(
            id: postId,
            author: author,
            title: title,
            text: text,
            localImagePath: localImagePath
        )
        await postManager.addPost(newPost)
        resetForm()
    }
}
