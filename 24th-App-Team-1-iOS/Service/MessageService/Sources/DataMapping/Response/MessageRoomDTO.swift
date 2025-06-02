//
//  MessageRoomDTO.swift
//  MessageService
//
//  Created by 최지철 on 5/26/25.
//

import Foundation
import MessageDomain

public struct MessageRoomDTO: Decodable {
    public let id: Int
    public let isMeMessageRoomOwner: Bool
    public let thumbnail: String
    public let isExistsUnreadMessage: Bool
    public let latestChatTime: Date
    public let isAnonymous: Bool
    public let name: String
    public let schoolName: String
    public let grade: Int
    public let classNumber: Int
    public let isBookmarked: Bool
    public let isBlocked: Bool
    public let isEver: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case isMeMessageRoomOwner
        case thumbnail
        case isExistsUnreadMessage
        case latestChatTime
        case isAnonymous
        case name
        case schoolName
        case grade
        case classNumber
        case isBookmarked
        case isBlocked
        case isEver
    }
}
