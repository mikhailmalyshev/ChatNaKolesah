//
//  ActiveChatCell.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 10.10.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure(with value: MChat)
}

class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseId: String = "ActiveChatCell"
    
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User Name", font:.laoSangamMN20())
    let lastMessage = UILabel(text: "Hey, bro?", font: .laoSangamMN18())
    let gradientView = UIView()
    
    func configure(with value: MChat) {
        friendImageView.image = UIImage(named: value.userImageString)
        friendName.text = value.username
        lastMessage.text = value.lastMessage
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - Setup Constraints

extension ActiveChatCell {
    private func setupConstraints() {
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        friendImageView.backgroundColor = .green
        gradientView.backgroundColor = .black
        addSubview(friendImageView)
        addSubview(gradientView)
        addSubview(friendName)
        addSubview(lastMessage)
        
        
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78)
        ])
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
        ])
        NSLayoutConstraint.activate([
            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
        ])
        NSLayoutConstraint.activate([
            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
        ])
        
    }
    
}
//MARK:- SwiftUI
import SwiftUI
struct ActiveChatProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ActiveChatProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: ActiveChatProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ActiveChatProvider.ContainerView>) {
            
        }
    }
}
