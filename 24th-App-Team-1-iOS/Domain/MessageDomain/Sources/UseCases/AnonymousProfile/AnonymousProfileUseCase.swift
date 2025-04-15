//
//  AnonymousProfileUseCase.swift
//  MessageDomain
//
//  Created by 최지철 on 4/15/25.
//

import Foundation

public protocol AnonymousProfileUseCase {
    func getAnonymousProfileList() async throws -> [AnonymousProfileEntity]
    func makeNewAnonymousProfile() async throws -> Bool
}
public final class AnonymousProfileUseCaseImpl: AnonymousProfileUseCase {
    public func makeNewAnonymousProfile() async throws -> Bool {
        return true
    }
    
    public func getAnonymousProfileList() async throws -> [AnonymousProfileEntity] {
        return []
    }
}
