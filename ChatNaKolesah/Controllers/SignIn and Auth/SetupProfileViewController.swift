//
//  SetupProfileViewController.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 03.10.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit
import FirebaseAuth

class SetupProfileViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Setup Profile", font: .avenir26())
    let fullNameLabel = UILabel(text: "Full Name")
    let aboutLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    let goToChatsButton = UIButton(backgroundColor: .buttonDark(), titleColor: .white, title: "Go to Chats!", cornerRadius: 4)
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let userName = currentUser.displayName {
            fullNameTextField.text = userName
        }
        
//        todo set google image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let fullImageView = AddPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
    }
    
    @objc private func goToChatsButtonTapped() {
        
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: currentUser.email!,
                                                userName: fullNameTextField.text,
                                                avatarImageString: "nil",
                                                description: aboutMeTextField.text,
                                                sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
                                                    switch result {
                                                    case .success(let muser):
                                                        self.showAlert(with: "Успешно!", and: "Приятного общения!", completion: {
                                                            let mainTabBar = MainTabBarController(currentUser: muser)
                                                            mainTabBar.modalPresentationStyle = .fullScreen
                                                            self.present(mainTabBar, animated: true, completion: nil)
                                                        })
                                                        print(muser)
                                                    case .failure(let error):
                                                        self.showAlert(with: "Ошибка!", and: error.localizedDescription)
                                                    }
        }
    }
    
}

//MARK:- Setup Constraints
extension SetupProfileViewController {
    
    private func setupConstraints() {
        
        let fullNameStackView = UIStackView(arrangedSubViews: [fullNameLabel, fullNameTextField], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubViews: [aboutLabel, aboutMeTextField], axis: .vertical, spacing: 0)
        let sexNameStackView = UIStackView(arrangedSubViews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 12)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubViews: [
            fullNameStackView, aboutMeStackView, sexNameStackView, goToChatsButton], axis: .vertical, spacing: 40)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
                                     welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
                                            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
               ])
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
                                           stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                           stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
              ])
    }
}

// MARK: - SwiftUI

import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let setupProfileViewController = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) -> SetupProfileViewController {
            return setupProfileViewController
        }
        
        func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) {
            
        }
    }
}
