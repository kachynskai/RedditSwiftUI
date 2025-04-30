//
//  PostListViewModel.swift
//  RedditSwiftUI
//
//  Created by Iryna on 23.04.2025.
//

import Foundation
@MainActor
final class PostListViewModel: ObservableObject{
    @Published var posts: [Post] = []
    @Published var isLoading = false
    
    private let postManager = SavedPostManager.shared
    
    func handleBookmarkTap(for post: Post) {
        print("Handling bookmark tap for post ID: \(post.id)")
        Task {
            await postManager.toggle(post: post)

            await MainActor.run {
                loadPosts()
            }
        }
    }
    
    func loadPosts(){
        isLoading = true
        Task {
            let loadedPosts = await postManager.loadAll()
            self.posts = loadedPosts
            self.isLoading = false
            print("Finished loading posts. Count: \(loadedPosts.count)")

        }
        
    }
}
