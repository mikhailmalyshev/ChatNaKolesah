//
//  PeopleViewController.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышallow read, write: if false; to true;ев on 03.10.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController {
    
    var users = [MUser]()
    private var usersListener: ListenerRegistration?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section,MUser>!
    
    enum Section: Int, CaseIterable {
        case users
        
        func description(usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }
    
    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    deinit {
        usersListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        createDotaSource()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOut))
        
        usersListener = ListenerService.shared.usersObserve(users: users, completion: { (result) in
            switch result {
            case .success(let users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        })!
    }
    
    @objc private func signOut() {
        let ac = UIAlertController(title: nil, message: "Are you sure you want to sing out?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Sing Out", style: .destructive, handler: { (_) in
                do {
                    try Auth.auth().signOut()
                    UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
                } catch {
                    print("Error singing out: \(error.localizedDescription)")
                }
            }))
        present(ac, animated: true)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayaut())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        
        collectionView.delegate = self
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
    
    private func reloadData(with searchText: String?) {
        let filtered = users.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(filtered, toSection: .users)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension PeopleViewController {
    private func createDotaSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
                
            }
        })
        dataSource?.supplementaryViewProvider = {
                   collectionView, kind, indexPath in
                   guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Can not create new section header")}
                   guard  let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.configure(text: section.description(usersCount: items.count), font: .systemFont(ofSize: 36, weight: .light), textColor: .label)
                   return sectionHeader
                   
               }
    }
    
    
    
    
}
extension PeopleViewController {
    private func createCompositionalLayaut() -> UICollectionViewLayout {
          let layout = UICollectionViewCompositionalLayout { (sectionIndex, layuotEnviroment) -> NSCollectionLayoutSection? in
              
              guard let section = Section(rawValue: sectionIndex) else {
                             fatalError("Unknown section kind")
                         }
              
              switch section {
              case .users:
                return self.createUsersSection()
            }
          }
          let config = UICollectionViewCompositionalLayoutConfiguration()
          config.interSectionSpacing = 20
          layout.configuration = config
          return layout
      }
    
    private func createUsersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 15, bottom: 0, trailing: 15)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        return sectionHeader
    }
}

//MARK: - UISearchBarDelegate

extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}

//MARK: - UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSource.itemIdentifier(for: indexPath) else { return }
        let profileVC = ProfileViewController(user: user)
        present(profileVC, animated: true, completion: nil)
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
