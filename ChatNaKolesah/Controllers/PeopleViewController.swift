//
//  PeopleViewController.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 03.10.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    let users = Bundle.main.decode([MUser].self, from: "users.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupSearchBar()
        
        users.forEach { (user) in
            print(user.username)
        }
    }
    
    private func setupSearchBar() {
           navigationController?.navigationBar.barTintColor = .mainWhite()
           navigationController?.navigationBar.shadowImage = UIImage()
           let searchController = UISearchController(searchResultsController: nil)
           navigationItem.searchController = searchController
           navigationItem.hidesSearchBarWhenScrolling = false
           searchController.hidesNavigationBarDuringPresentation = false
           searchController.obscuresBackgroundDuringPresentation = false
           searchController.searchBar.delegate = self
       }
}

//MARK: - UISearchBarDelegate

extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
}

//MARK:- SwiftUI
import SwiftUI
struct PeopleVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: PeopleVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PeopleVCProvider.ContainerView>) {
            
        }
    }
}
