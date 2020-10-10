//
//  UIimageView + extenstion.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 26.09.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
        
    }
}
