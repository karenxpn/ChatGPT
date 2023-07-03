//
//  ContentView.swift
//  ChatGPT
//
//  Created by Karen Mirakyan on 03.07.23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.chatMessages) { message in
                                messageView(message)
                            }
                            
                            Color.clear
                                .frame(height: 1)
                                .id("btm")
                        }
                    }.onReceive(viewModel.$chatMessages.throttle(for: 0.5, scheduler: RunLoop.main, latest: true)) { messages in
                        guard !messages.isEmpty else { return }
                        withAnimation {
                            proxy.scrollTo("btm")
                        }
                    }
                }
                
                HStack {
                    TextField("Message...", text: $viewModel.message, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    
                    if viewModel.isWaitingForResponse {
                        ProgressView()
                            .padding()
                    } else {
                        Button("Send") {
                            sendMessage()
                        }
                    }
                }.padding()
            }.navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.automatic)
        }

    }
    
    func messageView(_ message: ChatMessage) -> some View {
        HStack {
            if message.owner == .user {
                Spacer(minLength: 60)
            }
            
            if !message.text.isEmpty {
                VStack {
                    Text(message.text)
                        .foregroundColor(message.owner == .user ? .white : .black)
                        .padding(12)
                        .background(message.owner == .user ? .blue : .gray.opacity(0.1))
                        .cornerRadius(16)
                        .overlay(alignment: message.owner == .user ? .topTrailing : .topLeading) {
                            Text(message.owner.rawValue.capitalized)
                                .foregroundColor(.gray)
                                .font(.caption)
                                .offset(y: -16)
                        }
                }
            }
            
            if message.owner == .assistant {
                Spacer(minLength: 60)
            }
        }.padding(.horizontal)
    }
    
    func sendMessage() {
        Task {
            do {
                try await viewModel.sendMessage()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
