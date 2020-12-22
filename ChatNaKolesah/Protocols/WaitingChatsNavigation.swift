//
//  WaitingChatsNavigation.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 22.12.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import Foundation

protocol WaitingChatsNavigation: class {
    func removeWaitingChat(chat: MChat)
    func chatToActive(chat: MChat)
}
