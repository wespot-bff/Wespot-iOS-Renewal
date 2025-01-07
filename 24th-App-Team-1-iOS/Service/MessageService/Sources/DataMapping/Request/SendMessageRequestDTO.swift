//
//  SendMessageRequestDTO.swift
//  MessageService
//
//  Created by 최지철 on 1/6/25.
//

import Foundation

public struct SendMessageRequestDTO: Encodable {
    let content: String
    let reciverId: Int
    let senderName: String
    let isAnonymous: Bool
}
