//
//  PostListView.swift
//  RedditSwiftUI
//
//  Created by Iryna on 22.04.2025.
//

import SwiftUI

struct PostListView: View {
    @EnvironmentObject var navigator: NavigationManager
    @StateObject private var postListVM = PostListViewModel()
    var body: some View {
        VStack(spacing: 0){
            PageTitleView(title: "All posts")
            if postListVM.isLoading{
                Spacer()
                ProgressView("Loading Posts")
                Spacer()
            }else if postListVM.posts.isEmpty{
                ContentUnavailableView {
                    Label("No Posts Yet", systemImage: "clipboard")
                } description: {
                    Text("Create your first post by tapping the '+' button at the bottom or the button below.")
                } actions: {
                    ButtonView(buttonText: "Create Post Now", action: {navigator.goToCreatePost()}, isDisabled: false)
                }
                .accentColor(Color("MainColor"))
            }
            else{
                ScrollView{
                    LazyVStack(spacing: 10){
                        ForEach(postListVM.posts){ post in
                            SinglePostView(post: post, onToggleSave: { tappedPost in
                                postListVM.handleBookmarkTap(for: tappedPost)
                            })
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 5)
        .onAppear{
            postListVM.loadPosts()
        }
    }
}

#Preview {
    PostListView()
}
