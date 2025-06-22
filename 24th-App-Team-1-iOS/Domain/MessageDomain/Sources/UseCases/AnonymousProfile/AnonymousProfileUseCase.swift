//
//  AnonymousProfileUseCase.swift
//  MessageDomain
//
//  Created by 최지철 on 4/15/25.
//

import Foundation

public protocol AnonymousProfileUseCase {
    func getAnonymousProfileList(receiverId: Int) async throws -> [AnonymousProfileEntity]
}
public final class AnonymousProfileUseCaseImpl: AnonymousProfileUseCase {
    
    private let repository: MessageRepositoryProtocol
    
    public init(repository: MessageRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getAnonymousProfileList(receiverId: Int) async throws -> [AnonymousProfileEntity] {
        let profileList = try await repository.fetchAnonymousProfileList(receiverId: 0)
        return profileList
    }
}
