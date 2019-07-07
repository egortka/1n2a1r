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

class ChatVC: UITableViewController {
    
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
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // configure collection view
        tableView.backgroundColor = .white
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .interactive
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .white
        
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
            
            self.tableView.scrollToLast()
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - CollectionView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let dummyCell = MessageCell(frame: frame)
        dummyCell.message = messages[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(60, estimatedSize.height)
        return height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reportAction = UIContextualAction(style: .normal, title: "Report") { (action, view, nil) in
            self.report(message: self.messages[indexPath.item])
        }
        
        reportAction.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        let blockAction = UIContextualAction(style: .normal, title: "Block") { (action, view, nil) in
            self.block(message: self.messages[indexPath.item])
        }
        
        blockAction.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [reportAction, blockAction])
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
    
    func configureNavigationBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
        self.navigationItem.title = "Back"
    }
    
    @objc func handleBackButton() {
        containerView.isHidden = true
        
        if let mainViewController = UIApplication.shared.keyWindow?.rootViewController as? MainViewController {
            mainViewController.selectedIndex = 0
        }
        
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
                navigationController.navigationBar.tintColor = .black
                self.present(navigationController, animated: false, completion: nil)
            }
        }
    }
    
    func fetchMessages() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        MESSAGES_REF.observe(.childAdded) { (result) in
            
            guard let dict = result.value as? Dictionary<String, AnyObject> else { return }
            guard let uid = dict["uid"] as? String else { return }
            
            BLOCKS_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
                
                if !snapshot.hasChild(uid) {
                    
                    Database.fetchUser(with: uid, complition: { (user) in
                        
                        let message = Message(with: user, dictionary: dict)
                        self.messages.append(message)
                        
                        self.tableView.reloadData()
                        self.tableView.scrollToLast()
                    })
                    
                }
            }
        }
    }
    
    func block(message: Message) {
        
        report(message: message)
        
        guard let blockerUid = Auth.auth().currentUser?.uid else { return }
        guard let blockedUid = message.user?.uid else { return }
        
        BLOCKS_REF.child(blockerUid).updateChildValues([blockedUid: 1])
        
        messages.removeAll()
        tableView.reloadData()
        
        fetchMessages()
    }
    
    func report(message: Message) {
        
        guard let reporterUid = Auth.auth().currentUser?.uid else { return }
        guard let reportedUid = message.user?.uid else { return }
        
        REPORTS_REF.child(reportedUid).updateChildValues([reporterUid: 1])
        tableView.reloadData()
    }
    

}
