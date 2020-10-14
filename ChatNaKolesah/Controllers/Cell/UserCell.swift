//
//  UserCell.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 14.10.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseId: String = "UserCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
    }
    func configure(with value: MChat) {
        print("")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
