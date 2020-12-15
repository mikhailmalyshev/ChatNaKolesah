//
//  MMessage.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 15.12.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit

struct MMessage: Hashable {
    let content: String
    let senderId: String
    let senderUsername: String
    var sendDate: Date
    let id: String?
    
    init(user: MUser, content: String) {
        self.content = content
        senderId = user.id
        senderUsername = user.username
        sendDate = Date()
        id = nil
    }
    
    var representation: [String: Any] {
        var rep: [String: Any] = [
            "created": sendDate,
            "senderId": senderId,
            "senderName": senderUsername,
            "content": content
        ]
        return rep
    }
}
