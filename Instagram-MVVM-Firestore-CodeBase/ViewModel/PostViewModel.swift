//
//  PostViewModel.swift
//  Instagram-MVVM-Firestore-CodeBase
//
//  Created by Toshiyana on 2022/02/16.
//

import Foundation

struct PostViewModel {
    
    private let post: Post
    
    var imageUrl: URL? { return URL(string: post.imageUrl) }
    
    var caption: String { return post.caption }
    
    var likes: Int { return post.likes }
    
    init(post: Post) {
        self.post = post
    }
}
