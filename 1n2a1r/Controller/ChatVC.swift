//
//  ChatVC.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 31/05/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "MessageCell"

class ChatVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    //var post: Post?
    var messages = [Message]()
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 5, width: 100, height: 50)
        containerView.backgroundColor = .white
        
        containerView.addSubview(postButton)
        postButton.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        postButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.addSubview(messageTextField)
        messageTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: postButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        let seporatorView = UIView()
        seporatorView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        containerView.addSubview(seporatorView)
        seporatorView.anchor(top: nil, left: containerView.leftAnchor, bottom: messageTextField.topAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        return containerView
    }()
    
    lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUploadPost), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // configure collection view
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // set title
        navigationItem.title = "Messages"
        
        // set back button
        configureNavigationBar()
        
        // fetch messages
        fetchMessages()
        
        checkUserIsLoggedIn()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            self.collectionView.scrollToLast()
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let dummyCell = MessageCell(frame: frame)
        dummyCell.message = messages[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: collectionView.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(60, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.item]
        return cell
    }
    
    // MARK: - Handlers
    
    @objc func handleUploadPost() {
        
        guard messageTextField.hasText else { return }
        //guard let postId = self.post?.postId else { return }
        guard let messageText = messageTextField.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Double(NSDate().timeIntervalSince1970)
        
        postButton.isEnabled = false
        
        let values = ["messageText": messageText,
                      "creationDate": creationDate,
                      "uid": uid] as [String : Any]
        
        MESSAGES_REF.childByAutoId().updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
            }
            else
            {
                self.messageTextField.text = nil
                self.postButton.isEnabled = true
            }
        }
    }
    
    func fetchMessages() {
        
        MESSAGES_REF.observe(.childAdded) { (snapshot) in
            
            guard let dict = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let uid = dict["uid"] as? String else { return }
            
            Database.fetchUser(with: uid, complition: { (user) in
                
                let message = Message(with: user, dictionary: dict)
                self.messages.append(message)
                
                self.collectionView.reloadData()
                self.collectionView.scrollToLast()
            })
        }
        
    }
    
    func configureNavigationBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
        self.navigationItem.title = "Back"
    }
    
    @objc func handleBackButton() {
        containerView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        
        // configure alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            
            do {
                // log out user
                try Auth.auth().signOut()
                
                self.dismiss(animated: true, completion: nil)
                
                print("Successfully logged out user")
                
            } catch {
                print("Failed to sign out")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func checkUserIsLoggedIn() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                // present log in screen
                let navigationController = UINavigationController(rootViewController: SignUpViewController())
                self.present(navigationController, animated: false, completion: nil)
            }
        }
    }
    

}
