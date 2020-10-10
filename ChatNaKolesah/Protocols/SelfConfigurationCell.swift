//
//  SelfConfigurationCell.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 10.10.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure(with value: MChat)
}
