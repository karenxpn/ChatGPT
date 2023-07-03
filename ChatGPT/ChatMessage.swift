//
//  ChatMessage.swift
//  ChatGPT
//
//  Created by Karen Mirakyan on 03.07.23.
//

import Foundation
struct ChatMessage: Identifiable {
    var id = UUID().uuidString
    var owner: MessageOwner
    var text: String
    
    init(owner: MessageOwner = .user, _ text: String) {
        self.owner = owner
        self.text = text
    }
}
