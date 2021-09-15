//
//  FeedCells.swift
//  WhatTheSport
//
//  Created by Adam Martin on 7/27/21.
//
import Foundation
import UIKit
import FirebaseFirestore

class PostCell: UITableViewCell {
    private var cellStackView: UIStackView!
    private var usernameLabel: UILabel!
    private var contentLabel: UILabel!
    private var reactionStack: UIStackView!
    private var reactButton: UIButton!
    private var viewCommentsButton: UIButton!
    private var likeButton: UIButton!
    private var likeCount: UILabel!
    private var teamLogo: UIImageView!
    private var profilePic: UIImageView!
    private var post: Post? = nil
    private var commentVC: CommentViewController? = nil
    private var navController: UINavigationController!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var cellConstraints: [NSLayoutConstraint] = []
        
        self.usernameLabel = UILabel(frame: .zero)
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.profilePic = UIImageView(frame: .zero)
        self.profilePic.translatesAutoresizingMaskIntoConstraints = false
        
        self.teamLogo = UIImageView(frame: .zero)
        self.teamLogo.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentLabel = UILabel(frame: .zero)
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = false
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        self.contentLabel.backgroundColor = background
        
        self.reactButton = UIButton(frame: .zero)
        self.reactButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        self.reactButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewCommentsButton = UIButton(frame: .zero)
        self.viewCommentsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.likeButton = UIButton(frame: .zero)
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.likeCount = UILabel(frame: .zero)
        self.likeCount.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews to content view
        self.contentView.addSubview(self.usernameLabel)
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.teamLogo)
        self.contentView.addSubview(self.profilePic)
        self.contentView.addSubview(self.reactButton)
        self.contentView.addSubview(self.viewCommentsButton)
        self.contentView.addSubview(self.likeButton)
        self.contentView.addSubview(self.likeCount)
        
        // Add constraints and edit subview attributes for username label
        self.usernameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cellConstraints.append(self.usernameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20))
        cellConstraints.append(self.usernameLabel.widthAnchor.constraint(equalToConstant: 250))
        cellConstraints.append(self.usernameLabel.heightAnchor.constraint(equalToConstant: 20))
        cellConstraints.append(self.usernameLabel.leadingAnchor.constraint(equalTo: self.profilePic.trailingAnchor, constant: 10))
        
        // Add constraints and edit subview attributes for content label
        self.contentLabel.numberOfLines = 0
        cellConstraints.append(self.contentLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20))
        cellConstraints.append(self.contentLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -100))
        cellConstraints.append(self.contentLabel.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 10))
        cellConstraints.append(self.contentLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor))
        
        // Add constraints and edit subview attributes for team logo image
        cellConstraints.append(self.teamLogo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10))
        cellConstraints.append(self.teamLogo.heightAnchor.constraint(equalToConstant: 40))
        cellConstraints.append(self.teamLogo.widthAnchor.constraint(equalToConstant: 40))
        cellConstraints.append(self.teamLogo.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20))
        
        // Add constraints and edit subview attributes for profile picture
        cellConstraints.append(self.profilePic.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10))
        cellConstraints.append(self.profilePic.heightAnchor.constraint(equalToConstant: 40))
        cellConstraints.append(self.profilePic.widthAnchor.constraint(equalToConstant: 40))
        cellConstraints.append(self.profilePic.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10))
        
        // Add constraints and edit subview attributes for react button
        self.reactButton.tintColor = UIColor.gray
        self.reactButton.addTarget(self, action: #selector(reactButtonPressed), for: .touchUpInside)
        cellConstraints.append(self.reactButton.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 10))
        cellConstraints.append(self.reactButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10))
        cellConstraints.append(self.reactButton.widthAnchor.constraint(equalToConstant: 50))
        cellConstraints.append(self.reactButton.heightAnchor.constraint(equalToConstant: 25))
        
        // Add constraints and edit subview attributes for view comments button
        self.viewCommentsButton.setTitle("", for: .normal)
        self.viewCommentsButton.setTitleColor(UIColor.gray, for: .normal)
        self.viewCommentsButton.addTarget(self, action: #selector(commentsButtonPressed), for: .touchUpInside)
        cellConstraints.append(self.viewCommentsButton.topAnchor.constraint(equalTo: self.reactButton.topAnchor))
        cellConstraints.append(self.viewCommentsButton.leadingAnchor.constraint(equalTo: self.reactButton.trailingAnchor, constant: 10))
        cellConstraints.append(self.viewCommentsButton.widthAnchor.constraint(equalToConstant: 150))
        cellConstraints.append(self.viewCommentsButton.heightAnchor.constraint(equalToConstant: 20))
        
        //Add constraints and edit subview attributes for like count label
        cellConstraints.append(self.likeCount.widthAnchor.constraint(equalToConstant: 30))
        cellConstraints.append(self.likeCount.heightAnchor.constraint(equalToConstant: 20))
        cellConstraints.append(self.likeCount.topAnchor.constraint(equalTo: self.reactButton.topAnchor))
        cellConstraints.append(self.likeCount.trailingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: -20))
        
        // Add constraints and edit subview attributes for like button
        self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        self.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        cellConstraints.append(self.likeButton.widthAnchor.constraint(equalToConstant: 20))
        cellConstraints.append(self.likeButton.heightAnchor.constraint(equalToConstant: 20))
        cellConstraints.append(self.likeButton.topAnchor.constraint(equalTo: self.reactButton.topAnchor))
        cellConstraints.append(self.likeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20))
        
        NSLayoutConstraint.activate(cellConstraints)    // Activate constraints
    }
    
    func setValues(postArg: Post, nav: UINavigationController) {
        self.post = postArg
        self.navController = nav
        self.usernameLabel.text = postArg.username
        self.contentLabel.text = postArg.content
        self.viewCommentsButton.setTitle("\(postArg.numComments) comments", for: .normal)
        self.likeCount.text = String(postArg.numLikes)
        self.teamLogo.image = UIImage(named: self.post!.team!)
        self.likeButton.tintColor = postArg.userLikedPost ? UIColor.red : UIColor.gray
        if self.profilePic.image == nil {
            let userDB = Firestore.firestore().collection("users")
            userDB.document(postArg.userID).getDocument { (document, error) in
                if let document = document, document.exists {
                    let url = document.get("URL") as! String
                    IO.downloadImage(str: url, imageView: self.profilePic, completion: nil)
                } else {
                    print("error retreiving firestore data")
                }
            }
        }
    }
    
    func changeTextColor(color: UIColor) {
        usernameLabel.textColor = color
        contentLabel.textColor = color
        likeCount.textColor = color
    }
    
    func changeContentColor(color: UIColor) {
        self.contentLabel.backgroundColor = color
    }
    
    @objc
    func commentsButtonPressed() {
        if self.commentVC == nil {
            self.commentVC = CommentViewController()
        }
        
        self.commentVC!.post = self.post
        self.navController.pushViewController(self.commentVC!, animated: true)
    }
    
    @objc
    func likeButtonPressed() {
        var newArray = post!.likeUserIDs
        newArray.append(fireUser!.documentID)
        let feedDB = Firestore.firestore().collection("posts")
        if self.post != nil && !self.post!.userLikedPost {
            feedDB.document(self.post!.postID).updateData([
                "numLikes": self.post!.numLikes + 1,
                "likeUserIDs": newArray
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    self.post!.numLikes += 1
                    self.post!.likeUserIDs = newArray
                    self.post!.userLikedPost = true
                    self.likeCount.text = String(self.post!.numLikes)
                    self.likeButton.tintColor = UIColor.red
                }
            }
        } else {
            var newArray = self.post!.likeUserIDs
            if let valIndex = self.post!.likeUserIDs.firstIndex(of: fireUser!.documentID) {
                _ = newArray.remove(at: valIndex)
            }
            feedDB.document(self.post!.postID).updateData([
                "numLikes": self.post!.numLikes - 1,
                "likeUserIDs": newArray
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    self.post!.numLikes -= 1
                    self.post!.likeUserIDs = newArray
                    self.post!.userLikedPost = false
                    self.likeCount.text = String(self.post!.numLikes)
                    self.likeButton.tintColor = UIColor.gray
                }
            }
        }
    }
    
    @objc
    func reactButtonPressed() {
        print("REACT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
