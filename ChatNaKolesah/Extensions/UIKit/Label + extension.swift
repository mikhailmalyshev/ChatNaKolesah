//
//  Label + extension.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 26.09.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
