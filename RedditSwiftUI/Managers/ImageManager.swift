//
//  ImageManager.swift
//  RedditSwiftUI
//
//  Created by Iryna on 30.04.2025.
//

import Foundation
import UIKit

final class ImageManager{
    static let shared = ImageManager()
    private let fileManager = FileManager.default
    private var directoryUrl: URL
    
    private init(){
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        directoryUrl = documentsURL.appendingPathComponent("PostImages")
        Task { await self.createDirectoryIfNeeded() }
    }
    
    private func createDirectoryIfNeeded() async {
        let exists = fileManager.fileExists(atPath: directoryUrl.path(percentEncoded: false))
        if !exists {
            do {
                try await Task.detached {
                    try self.fileManager.createDirectory(at: self.directoryUrl, withIntermediateDirectories: true, attributes: nil)
                }.value
                print("Directory PostImages was created")
            } catch {
                print("Error on creating directory stage: \(error)")
            }
        }
    }

    
    func saveImg(_ data: Data, for postId: String) async -> String?{
        let fileName = "\(postId).jpg"
        let fileUrl = directoryUrl.appendingPathComponent(fileName)
        do{
            try await Task.detached{ try data.write(to: fileUrl)}.value
            return fileName
        }catch{
            print("error in saving message")
            return nil
        }
    }
    
    func loadImg(from path: String) async -> UIImage?{
        let url = directoryUrl.appendingPathComponent(path)
        do{
            let data = try await Task.detached { try Data(contentsOf: url) }.value
            return UIImage(data: data)
        }catch{
            print("problems with loading img")
            return nil
        }
    }
    
    func deleteImg(with path: String) async {
        let url = directoryUrl.appendingPathComponent(path)
        do{
            try await Task.detached { try self.fileManager.removeItem(at: url) }.value
            print("image deleted")
        }catch{
            print("problems with deleting img")
        }
    }
}
