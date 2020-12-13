//
//  LoginViewController.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 03.10.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Welcome back!", font: .avenir26())
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    
    let googleButton = UIButton(backgroundColor: .white, titleColor: .black, title: "Google", isShadow: true)
    
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())

    let loginButton = UIButton(backgroundColor: .buttonDark(), titleColor: .white, title: "Login")
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    weak var delegate: AuthNavigatingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        googleButton.customizeGoogleButton()
        setupConstraints()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
    }
    @objc private func loginButtonTapped() {
        print(#function)
        AuthService.shared.login(email: emailTextField.text!,
                                 password: passwordTextField.text!) { (result) in
                                    switch result {
                                    case .success(let user):
                                        self.showAlert(with: "Успешно!", and: "Вы авторизированы!") {
                                            FirestoreService.shared.getUserData(user: user) { (result) in
                                                switch result {
                                                case .success(let muser):
                                                    let mainTabBar = MainTabBarController(currentUser: muser)
                                                    mainTabBar.modalPresentationStyle = .fullScreen
                                                    self.present(mainTabBar, animated: true, completion: nil)
                                                case .failure(_):
                                                    self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                                                }
                                            }
                                        }
                                    case .failure(let error):
                                        self.showAlert(with: "Ошибка!", and: error.localizedDescription)
                                    }
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
    
    @objc private func googleButtonTapped() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}

//MARK:- Setup Constraints
extension LoginViewController {
    private func setupConstraints() {
        let loginWithView = ButtonFromView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubViews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubViews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubViews: [loginWithView, orLabel, emailStackView, passwordStackView, loginButton],
                                    axis: .vertical,
                                    spacing: 40)
        
        signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubViews: [needAnAccountLabel, signUpButton],
                                          axis: .horizontal,
                                          spacing: 10)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                                     welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 60),
                                     stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                     stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
                                            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
               ])
        

    }
}

// MARK: - SwiftUI

import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let loginViewController = LoginViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) -> LoginViewController {
            return loginViewController
        }
        
        func updateUIViewController(_ uiViewController: LoginVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) {
            
        }
    }
}

