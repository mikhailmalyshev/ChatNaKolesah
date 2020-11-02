//
//  AuthNavigatingDelegate.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 22.10.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import Foundation

protocol AuthNavigatingDelegate: class {
    func toLoginVC()
    func toSignUpVC()
}
