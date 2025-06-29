//
//  MessageSettingUsecase.swift
//  MessageDomain
//
//  Created by 최지철 on 6/29/25.
//

import Foundation
import RxSwift

public protocol MessageSettingUsecase {
    func fetchBlockMessgeList() async throws -> [MessageRoomEntity]
    func unBlockMessage(messageId: Int) -> Single<Bool>
}
public final class MessageSettingUsecaseImpl: MessageSettingUsecase {
    
    public func unBlockMessage(messageId: Int) -> RxSwift.Single<Bool> {
        return repository.blockMessage(messageId: messageId)
    }
    
    private let repository: MessageRepositoryProtocol
    
    public init(repository: MessageRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchBlockMessgeList() async throws -> [MessageRoomEntity] {
        return try await repository.fetchBlockMessgeList()
    }

}

