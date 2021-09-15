//
//  FeedObjects.swift
//  WhatTheSport
//
//  Created by Adam Martin on 7/27/21.
//

import Foundation

class Post {
    var postID: String
    var sport: String
    var team: String?
    var content: String
    var userID: String
    var username: String
    var numLikes: Int
    var numComments: Int
    var userLikedPost: Bool
    var likeUserIDs: [String]
    
    init(postIDArg: String, sportArg: String, teamArg: String?, contentArg: String, userIDArg: String, usernameArg: String, numLikesArg: Int, numCommentsArg: Int, userLikedPostArg: Bool, likeUserIDsArg: [String]) {
        self.postID = postIDArg
        self.sport = sportArg
        self.team = teamArg
        self.content = contentArg
        self.userID = userIDArg
        self.username = usernameArg
        self.numLikes = numLikesArg
        self.numComments = numCommentsArg
        self.userLikedPost = userLikedPostArg
        self.likeUserIDs = likeUserIDsArg
    }
}

class Comment {
    var commentID: String
    var postID: String
    var username: String
    var userID: String
    var content: String
    
    init(commentIDArg: String, postIDArg: String, usernameArg: String, userIDArg: String, contentArg: String) {
        self.commentID = commentIDArg
        self.postID = postIDArg
        self.username = usernameArg
        self.userID = userIDArg
        self.content = contentArg
    }
}
