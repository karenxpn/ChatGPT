//
//  ViewModel.swift
//  ChatGPT
//
//  Created by Karen Mirakyan on 03.07.23.
//

import Foundation
import Combine
import ChatGPTSwift

class ViewModel: ObservableObject {
    
    let api = ChatGPTAPI(apiKey: Credentials.api_key)
    
    @Published var message = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var isWaitingForResponse = false
    
    @MainActor func sendMessage() async throws {
        let userMessage = ChatMessage(message)
        chatMessages.append(userMessage)
        isWaitingForResponse = true

        let assistantMessage = ChatMessage(owner: .assistant, "")
        chatMessages.append(assistantMessage)
        let stream = try await api.sendMessageStream(text: message)
        message = ""
        
        for try await line in stream {
            if let lastMessage = chatMessages.last {
                let text = lastMessage.text
                let newMessage = ChatMessage(owner: .assistant, text + line)
                chatMessages[chatMessages.count-1] = newMessage
            }
        }
        
        isWaitingForResponse = false
    }
}
