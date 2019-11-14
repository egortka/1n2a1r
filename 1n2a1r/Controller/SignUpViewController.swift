//
//  SignUpViewController.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 31/05/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageSelected = false
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo_white"))
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return view
    }()
    
    let addPhotoButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        let attributedString = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedString.append(NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]))
        button.setAttributedTitle(attributedString, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        
        configureViewComponents()
        
//        view.addSubview(alreadyHaveAccountButton)
//        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    //MARK: - UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //select image
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            
            imageSelected = false
            return
        }
        
        //set image selected
        imageSelected = true
        
        //configure addPhotoButton with selected image
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 2
        addPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
        formValidation()
    }
    
    //MARK: - Buttons handlers
    
    @objc func handleSelectProfilePhoto() {
        
        //configer image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        //present image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignup() {
        
        //properties
//        guard let email = emailTextField.text else { return }
//        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = addPhotoButton.imageView?.image else { return }
        
        Auth.auth().signInAnonymously() { (result, error) in
            
            // handle error
            if let error = error {
                print("Failed to create user with error: \(error.localizedDescription)")
                return
            }
            
            // data to upload
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else { return }
            
            // place image to firebase storage
            let fileName = NSUUID().uuidString
            let storageRef = STORAGE_PROFILE_IMAGES_REF.child(fileName)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                //handle error
                if let error = error {
                    print("Failed to upload profile image", error.localizedDescription)
                    return
                }
                
                // profile image url
                storageRef.downloadURL(completion: { (downloadURL, error) in
                    
                    guard let profileImageUrl = downloadURL?.absoluteString else {
                        print("DEBUG: Profile image url is nil")
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    let dictionaryValues = [ "username": username,
                                             "profileImageUrl": profileImageUrl]
                    
                    let values = [uid: dictionaryValues]
                    
                    //save user data to database
                    USERS_REF.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            print("Failed to save data to data base", error)
                            return
                        }
                        print("Successfully created user and saved data to database")
                        
                        guard let mainViewController = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else { return }
                        mainViewController.tabBarController?.selectedIndex = 2
                        
                        let chatViewController = ChatVC()
                        let navigationController = UINavigationController(rootViewController: chatViewController)
                        navigationController.navigationBar.tintColor = .black
                        self.present(navigationController, animated: true, completion: nil)
                        
                    })
                })
                
            })
        }
    }
    
    //MARK: - Utils methods
    
    @objc func formValidation() {
        
        guard
//            emailTextField.hasText,
            usernameTextField.hasText,
//            passwordTextField.hasText,
            imageSelected else {
                signupButton.isEnabled = false
                signupButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                return
        }
        
        signupButton.isEnabled = true
        signupButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func configureViewComponents() {
        
//        view.addSubview(logoContainerView)
//        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 140)
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, signupButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 96)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: nil, left: nil, bottom: stackView.topAnchor, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 40, paddingRight: 0, width: 140, height: 140)
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
