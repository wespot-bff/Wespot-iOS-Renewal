//
//  MessageContentModel.swift
//  MessageDomain
//
//  Created by 최지철 on 1/15/25.
//

import Foundation

public struct MessageContentModel {
    public let studentInfo: String
    public let date: String
    public let isRead: Bool
    public let isBlocked: Bool
    public let isReported: Bool
    public let content: String
    public let senderName: String
    public let reciverName: String
    public let messageId: Int
    
    public init(studentInfo: String,
                date: String,
                isRead: Bool,
                isBlocked: Bool,
                isReported: Bool,
                content: String,
                senderName: String,
                reciverName: String,
                messageId: Int) {
        self.studentInfo = studentInfo
        self.date = date
        self.isRead = isRead
        self.isBlocked = isBlocked
        self.isReported = isReported
        self.content = content
        self.senderName = senderName
        self.reciverName = reciverName
        self.messageId = messageId
    }
}
