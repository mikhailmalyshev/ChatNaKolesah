//
//  ViewController.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 24.09.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnBoardLabel = UILabel(text: "Already on Board")
    
    
    let emailButton = UIButton(backgroundColor: .buttonDark(), titleColor: .white, title: "Email")
    let loginButton = UIButton(backgroundColor: .buttonRed(), titleColor: .black, title: "Login", isShadow: true)
     let googleButton = UIButton(backgroundColor: .white, titleColor: .black, title: "Google", isShadow: true)
    
    let signUpVC = SignUpViewController()
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleButton.customizeGoogleButton()
        view.backgroundColor = .white
        setupConstraints()
        
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func emailButtonTapped() {
        print(#function)
        present(signUpVC, animated: true, completion: nil)
    }
    @objc private func loginButtonTapped() {
        print(#function)
        present(loginVC, animated: true, completion: nil)
    }
}
//MARK:- Setup Constraints
extension AuthViewController {
    private func setupConstraints() {
          logoImageView.translatesAutoresizingMaskIntoConstraints = false
          
          let googleView = ButtonFromView(label: googleLabel, button: googleButton)
          let emailView = ButtonFromView(label: emailLabel, button: emailButton)
          let loginView = ButtonFromView(label: alreadyOnBoardLabel, button: loginButton)
          
          let stackView = UIStackView(arrangedSubViews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
          stackView.translatesAutoresizingMaskIntoConstraints = false
          
          view.addSubview(logoImageView)
          view.addSubview(stackView)
          
          NSLayoutConstraint.activate([
          logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160.0),
                 logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
          
          ])
          
          NSLayoutConstraint.activate([
              stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
              stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
              stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
              
          ])
      }
}


// MARK: - SwiftUI

import SwiftUI

struct LogincVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = AuthViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<LogincVCProvider.ContainerView>) -> AuthViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: LogincVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LogincVCProvider.ContainerView>) {
            
        }
    }
}
