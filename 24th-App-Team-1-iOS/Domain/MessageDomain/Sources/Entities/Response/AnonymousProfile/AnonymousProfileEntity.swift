//
//  AnonymousProfileEntity.swift
//  MessageDomain
//
//  Created by 최지철 on 4/14/25.
//

import Foundation

public struct AnonymousProfileEntity {
    public let id: Int
    public let name: String
    public let image: String
    public let recentlyTalk: String?
    public let myTurnToAnswer: Bool

    // ← 이 부분이 꼭 public 이어야 합니다
    public init(
        id: Int,
        name: String,
        image: String,
        recentlyTalk: String?,
        myTurnToAnswer: Bool
    ) {
        self.id              = id
        self.name            = name
        self.image           = image
        self.recentlyTalk    = recentlyTalk
        self.myTurnToAnswer  = myTurnToAnswer
    }
}
