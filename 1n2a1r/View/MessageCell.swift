//
//  MessageCell.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 12/03/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    // MARK: - Properties
    
    var message: Message? {
        
        didSet {
            
            guard let profileImageUrl = message?.user?.profileImageUrl else { return }
            guard let username = message?.user?.username else { return }
            guard let messageText = message?.messageText else { return }
            //guard let creationDate = comment?.creationDate else { return }
            
            self.profileImageView.loadImage(with: profileImageUrl)
            
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
            attributedText.append(NSAttributedString(string: " \(messageText)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
//            attributedText.append(NSAttributedString(string: " 2d", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            messageTextView.attributedText = attributedText
  
        }
        
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    let seporator: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        self.addSubview(messageTextView)
        messageTextView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        
        self.addSubview(seporator)
        seporator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 60, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
