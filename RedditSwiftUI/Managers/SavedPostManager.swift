//
//  PostManager.swift
//  RedditSwiftUI
//
//  Created by Iryna on 23.04.2025.
//

import Foundation
final class SavedPostManager{
    
    static let shared = SavedPostManager()
    private let fileManager = FileManager.default
    
    private let fileURL: URL
    private let imageManager = ImageManager.shared
    private init() {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsURL.appendingPathComponent("savedPosts.json")
    }
    
    func loadAll() async -> [Post] {
        let path = fileURL.path
        guard await Task.detached(operation: { self.fileManager.fileExists(atPath: path) }).value else {
            print("File with posts not exist.")
            return []
        }
        do {
            let data = try await Task.detached { try Data(contentsOf: self.fileURL) }.value
            let posts = try await Task.detached { try JSONDecoder().decode([Post].self, from: data) }.value
            return posts.sorted { $0.creationDate > $1.creationDate }
        } catch {
            print("Error loading/decoding savedPosts: \(error)")
            return []
        }
    }
    private func saveInFile(_ posts: [Post]) async {
        do {
            let data = try await Task.detached { try JSONEncoder().encode(posts) }.value
            try await Task.detached { try data.write(to: self.fileURL, options: [.atomic]) }.value
            print("Saved post updated.")
        } catch {
            print("Error encoding/saving 'savedPosts.json': \(error)")
        }
    }
    
    func addPost(_ post: Post) async {
        var allPosts = await loadAll()
        if !allPosts.contains(where: { $0.id == post.id }) {
            allPosts.append(post)
            await saveInFile(allPosts)
            print("Post \(post.id) added.")
        } else {
            print("Post \(post.id) already exists.")
        }
    }
    func toggle(post: Post) async {
        var posts = await loadAll()
        if let idx = posts.firstIndex(where: {$0.id == post.id}) {
            let postToRemove = posts.remove(at: idx)
            print("Post \(post.id) removed")
            if let imagePath = postToRemove.localImgUrl {
                print("Deleting associated image \(imagePath)...")
                await self.imageManager.deleteImg(with: imagePath)
            }
        } else {
            posts.append(post)
            print("Post \(post.id) added")
        }
        await saveInFile(posts)
    }
    func isPostSaved(id: String) async -> Bool {
        let posts = await loadAll()
        return posts.contains(where: {$0.id == id})
    }
}
