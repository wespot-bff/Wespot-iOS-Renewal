//
//  WriteMessageUseCase.swift
//  MessageDomain
//
//  Created by 최지철 on 1/6/25.
//

import RxSwift

public protocol WriteMessageUseCase {
    func checkProfanity(message: String)
}
public final class WriteMessageUseCaseImpl: WriteMessageUseCase {
    
    private let repository: MessageRepositoryProtocol
    
    public init(repository: MessageRepositoryProtocol) {
        self.repository = repository
    }
    
    public func checkProfanity(message: String) {
        
    }
}
