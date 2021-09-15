//
//  CommentViewController.swift
//  WhatTheSport
//
//  Created by Adam Martin on 8/8/21.
//

import UIKit
import FirebaseFirestore

let commentCellIdentifier = "CommentCell"

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var comments: [Comment] = []
    
    private var commentTableView: UITableView!
    private var createCommentView: UIView!
    private var writeView: UIView!
    private var profilePicView: UIImageView!
    private var writeSomethingLabel: UILabel!
    private var createCommentVC: CreateCommentViewController? = nil
    
    var post: Post? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CommentCell
        let row = indexPath.row
        let currComment = self.comments[row]
        cell.setValues(commentArg: currComment)
        
        cell.backgroundColor = UIColor(rgb: Constants.Colors.lightOrange)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(rgb: Constants.Colors.orange)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        var constraints: [NSLayoutConstraint] = []
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.commentTableView = UITableView(frame: .zero)
        self.commentTableView.translatesAutoresizingMaskIntoConstraints = false
        self.commentTableView.register(CommentCell.self, forCellReuseIdentifier: cellIdentifier)
        self.commentTableView.dataSource = self
        self.commentTableView.delegate = self
        self.commentTableView.backgroundColor = UIColor(rgb: Constants.Colors.lightOrange)
        self.commentTableView.separatorStyle = .none
        
        self.createCommentView = UIView(frame: .zero)
        self.createCommentView.translatesAutoresizingMaskIntoConstraints = false
        self.createCommentView.backgroundColor = UIColor(rgb: Constants.Colors.orange)
        
        self.writeView = UIView(frame: .zero)
        self.writeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writeViewPressed)))
        self.writeView.translatesAutoresizingMaskIntoConstraints = false
        self.writeView.backgroundColor = UIColor.systemGray5
        
        self.profilePicView = UIImageView(frame: .zero)
        self.profilePicView.translatesAutoresizingMaskIntoConstraints = false
        self.profilePicView.image = UIImage(named: "knicksLogo")
        
        self.writeSomethingLabel = UILabel(frame: .zero)
        self.writeSomethingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.writeSomethingLabel.lineBreakMode = .byWordWrapping
        self.writeSomethingLabel.text = "Write a comment"
        
        self.view.addSubview(self.commentTableView)
        self.view.addSubview(self.createCommentView)
        self.createCommentView.addSubview(self.writeView)
        self.createCommentView.addSubview(self.profilePicView)
        self.writeView.addSubview(self.writeSomethingLabel)
        
        constraints.append(self.commentTableView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, constant: -75))
        constraints.append(self.commentTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor))
        constraints.append(self.commentTableView.topAnchor.constraint(equalTo: safeArea.topAnchor))

        constraints.append(self.createCommentView.heightAnchor.constraint(equalToConstant: 75))
        constraints.append(self.createCommentView.widthAnchor.constraint(equalTo: self.view.widthAnchor))
        constraints.append(self.createCommentView.topAnchor.constraint(equalTo: self.commentTableView.bottomAnchor))
        
        constraints.append(self.profilePicView.leadingAnchor.constraint(equalTo: self.createCommentView.leadingAnchor, constant: 10))
        constraints.append(self.profilePicView.topAnchor.constraint(equalTo: self.createCommentView.topAnchor, constant: 20))
        constraints.append(self.profilePicView.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(self.profilePicView.widthAnchor.constraint(equalToConstant: 50))
        
        constraints.append(self.writeView.heightAnchor.constraint(equalToConstant: 40))
        constraints.append(self.writeView.widthAnchor.constraint(lessThanOrEqualToConstant: 250))
        constraints.append(self.writeView.centerYAnchor.constraint(equalTo: self.profilePicView.centerYAnchor))
        constraints.append(self.writeView.leadingAnchor.constraint(equalTo: self.profilePicView.trailingAnchor, constant: 10))
        
        constraints.append(self.writeSomethingLabel.heightAnchor.constraint(equalToConstant: 20))
        constraints.append(self.writeSomethingLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250))
        constraints.append(self.writeSomethingLabel.centerYAnchor.constraint(equalTo: self.writeView.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
        
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        commentTableView.backgroundColor = background
        commentTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.comments = []
        getComments()
        if self.commentTableView != nil {
            self.commentTableView.reloadData()
        }
        let background: UIColor = currentUser!.settings!.dark ? .black : UIColor(rgb: Constants.Colors.lightOrange)
        if self.commentTableView != nil {
            self.commentTableView.backgroundColor = background
            self.commentTableView.reloadData()
        }

    }
    
    @objc
    func writeViewPressed() {
        if self.createCommentVC == nil {
            self.createCommentVC = CreateCommentViewController()
        }
        self.createCommentVC!.delegate = self
        self.navigationController?.pushViewController(self.createCommentVC!, animated: true)
    }
    
    func getComments() {
        let commentsDB = Firestore.firestore().collection("comments")
        commentsDB.whereField("postID", isEqualTo: post!.postID).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting comments: \(err)")
            } else {
                for comment in querySnapshot!.documents {
                    self.comments.append(Comment(commentIDArg: comment.documentID, postIDArg: comment.get("postID") as! String, usernameArg: comment.get("username") as! String, userIDArg: comment.get("userID") as! String, contentArg: comment.get("content") as! String))
                }
            }
            self.commentTableView.reloadData()
        }
    }
}
