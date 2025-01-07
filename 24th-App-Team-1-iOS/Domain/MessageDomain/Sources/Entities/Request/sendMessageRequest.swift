//
//  sendMessageRequest.swift
//  MessageDomain
//
//  Created by 최지철 on 1/6/25.
//

import Foundation

public struct SendMessageRequest: Equatable {
    let content: String
    let reciverId: Int
    let senderName: String
    let isAnonymous: Bool
}
