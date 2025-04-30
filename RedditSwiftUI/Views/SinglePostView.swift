//
//  SinglePostView.swift
//  RedditSwiftUI
//
//  Created by Iryna on 23.04.2025.
//

import SwiftUI

struct SinglePostView: View {
    @State private var postImage: UIImage? = nil
//    @StateObject private var singleVM = SinglePostViewModel(post: post)
    private let imageManager = ImageManager.shared
    var post: Post
    var onToggleSave: (Post) -> Void
    
    var body: some View {
        VStack(alignment:.leading, spacing: 10){
            HStack(spacing: 0){
                Text("\(post.author) • \(post.creationDate.timeAgo()) • \(post.domain)")
                    .foregroundStyle(Color("AdditionalInfoColor"))
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                Spacer()
                Button{
                    onToggleSave(post)
                }label: {
                    Image(systemName: post.saved ? "bookmark.fill" : "bookmark")
                        .foregroundColor(Color("MainColor"))
                        .frame(minHeight: 30)
                }

            }
            .padding(0)
            Text(post.title)
                .font(.system(size: 20))
                .fontWeight(.bold)
            if let postText = post.text{
                Text(postText)
            }
            if let img = postImage{
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }
            HStack(spacing: 20){
                Label("\(post.rating)", systemImage: "arrowshape.up.fill")
                Label("\(post.numComments)", systemImage: "bubble.left.fill")
                Spacer()
                Label("Share", systemImage: "square.and.arrow.up")
            }
            .fontWeight(.medium)
        }
        .padding(15)
        .foregroundStyle(Color("MainColor"))
        .background(Color("BackgroundColor"))
        .onAppear{
            Task{
                await loadImage()
            }
        }
    }
    private func loadImage() async{
        if let localPath = post.localImgUrl {
            let loadedImage = await imageManager.loadImg(from: localPath)
            self.postImage = loadedImage
        }
    }
}

#Preview {
    let previewToggleSaveAction: (Post) -> Void = { post in
            print("Preview: Bookmark tapped for post ID: \(post.id). Current saved state: \(post.saved)")
        }
    VStack(spacing: 12) {
        SinglePostView(post: Post(id:UUID().uuidString, author: "test_user", title: "Anyone else think this should show the battery percentage of all of your devices?", text:"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum" , localImagePath: nil), onToggleSave: previewToggleSaveAction)

    }
    .background(Color.gray.opacity(0.1))
}
