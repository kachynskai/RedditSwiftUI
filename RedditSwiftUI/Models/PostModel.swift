//
//  PostModel.swift
//  RedditSwiftUI
//
//  Created by Iryna on 22.04.2025.
//

import Foundation
struct Post: Identifiable, Codable{
    let id: String
    let author: String
    let creationDate: Date
    let domain: String
    let title: String
    let text: String?
    let rating: Int
    let numComments: Int
    let webUrl: String?
    let localImgUrl: String?
    let apiImgUrl: String?
    var saved: Bool
    var timeAgo: String {
            creationDate.timeAgo()
    }
    
    //constructor for local posts
    init(id:String, author: String, title:String, text: String?, localImagePath: String?){
        self.id = id
        self.author = author
        self.creationDate = Date()
        self.domain = "own_domain"
        self.title = title
        self.text = text
        self.rating = 0
        self.numComments = 0
        self.webUrl = nil
        self.localImgUrl = localImagePath
        self.apiImgUrl = nil
        self.saved = true
    }
    init(id: String,
         author: String,
         creationDate: Date,
         domain: String,
         title: String,
         text: String?,
         rating: Int,
         numComments: Int,
         webUrl: String?,
         localImgUrl: String?,
         apiImgUrl: String?,
         saved: Bool)
    {
        self.id = id
        self.author = author
        self.creationDate = creationDate
        self.domain = domain
        self.title = title
        self.text = text
        self.rating = rating
        self.numComments = numComments
        self.webUrl = webUrl
        self.localImgUrl = localImgUrl
        self.apiImgUrl = apiImgUrl
        self.saved = saved
    }
}

extension Date {
    func timeAgo() -> String {
        let now = Date()
        let difference = now.timeIntervalSince(self)
        if difference < 60 {
            return "now"
        } else if difference < 3600 {
            return "\(Int(difference / 60))m"
        } else if difference < 86400 {
            return "\(Int(difference / 3600))h"
        } else {
            return "\(Int(difference / 86400))d"
        }
    }
}
