//
//  AddPostView.swift
//  RedditSwiftUI
//
//  Created by Iryna on 22.04.2025.
//
import PhotosUI
import SwiftUI

struct CreatePostView: View {
    @EnvironmentObject var navigator: NavigationManager
    @StateObject private var createPostVM = CreatePostViewModel()
    @State private var selectedPhoto: PhotosPickerItem?
    private func handleSelectedPhoto(newItem: PhotosPickerItem?) {
        Task {
            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                createPostVM.selectedImageData = data
                if let uiImage = UIImage(data: data) {
                    createPostVM.selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }
    private var isFormValid: Bool{
        !createPostVM.text.isEmpty && !createPostVM.title.isEmpty
    }
    var body: some View {
        VStack(spacing: 0){
            PageTitleView(title: "Create new post")
            Form{
                Section ("Title"){
                    TextField("Enter title of your new post", text: $createPostVM.title)
                }
                Section("Text"){
                    TextEditor(text: $createPostVM.text)
                        .frame(height: 80)
                }
                Section("Add photo (optional)"){
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if let image = createPostVM.selectedImage {
                            
                            ZStack (alignment: .topTrailing) {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                Button{
                                    createPostVM.removeSelectedPhoto()
                                    self.selectedPhoto = nil
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .padding(3)
                                }
                            }
                        } else {
                            ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                                .padding(0)
                        }
                    }
                    .accentColor(Color("MainColor"))
                    .onChange(of: selectedPhoto) { _, newItem in
                                            handleSelectedPhoto(newItem: newItem)
                                        }
                }
                Section("Author"){
                    Text(createPostVM.author.isEmpty ? "Author name is empty!!" : createPostVM.author)
                        .foregroundColor(createPostVM.author.isEmpty ? .red : .gray)
                }
            }
            ButtonView(
                buttonText: "Save Post",
                action: {
                    Task{
                        await createPostVM.savePost()
                        navigator.goToPosts()
                    }
                },
                isDisabled: !isFormValid
            )
            .padding(10)
        }
        .onAppear{
            createPostVM.loadAuthoreName()
        }
        .onDisappear{
            createPostVM.resetForm()
        }
        .alert("Author Name Required", isPresented: $createPostVM.showSettingsAlert) {
            Button("Go to Settings") {
                navigator.goToSettings()
            }
        } message: {
            Text("Please set your name in the Settings before creating a post")
        }
    }
}

#Preview {
    CreatePostView()
}
