//
//  MessageStroageUseCase.swift
//  MessageDomain
//
//  Created by 최지철 on 1/13/25.
//

import RxSwift

public protocol MessageStorageUseCase {
    func getMessage(query: GetMessageRequest) -> Single<ReceivedMessageResponseEntity>
}
public final class MessageStorageUseCaseImpl: MessageStorageUseCase {
    
    private let repository: MessageRepositoryProtocol
    
    public init(repository: MessageRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getMessage(query: GetMessageRequest) -> Single<ReceivedMessageResponseEntity> {
        return repository.getMessage(query: query)
    }
}
