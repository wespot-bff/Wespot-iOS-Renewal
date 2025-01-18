//
//  MessageStorageViewReactor.swift
//  MessageFeature
//
//  Created by eunseou on 7/20/24.
//

import MessageDomain
import Foundation
import Util

import ReactorKit


public final class MessageStorageReactor: Reactor {
    
    private let usecase: MessageStorageUseCase
    
    public struct State {
        var messageCount: Int = 0
        var tabState: MessageButtonTabEnum = .received
        @Pulse var recivedMessageList: [MessageContentModel] = []
        @Pulse var sentMessageList: [MessageContentModel] = []
        @Pulse var toastMessage: MessageContentModel?
        @Pulse var messageMode: MessageContentModel?
    }
    
    public enum Action {
        case loadMessages(cursorId: Int,
                          type: String)
        case receivedMessageButtonTapped
        case sentMessageButtonTapped
        case toastMessageDetail(MessageContentModel)
        case moreButtonTapped(MessageContentModel)
    }
    
    public enum Mutation {
        case setMessageCount(Int)
        case setButtonTabState(MessageButtonTabEnum)
        case setRecievedMessageList([MessageContentModel])
        case setSentMessageList([MessageContentModel])
        case setMessageToast(MessageContentModel)
        case setModeInfoMessage(MessageContentModel)
    }
    
    public var initialState: State
    
    public init(usecase: MessageStorageUseCase) {
        self.usecase = usecase
        self.initialState = State()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .receivedMessageButtonTapped:
            return Observable.just(.setButtonTabState(.received))
        case .loadMessages(let cursor, let type):
            return fetchMessageList(cursor: cursor, type: type)
        case .sentMessageButtonTapped:
            return Observable.just(.setButtonTabState(.sent))
        case .toastMessageDetail(let message):
            return Observable.just(.setMessageToast(message))
        case .moreButtonTapped(let message):
            return Observable.just(.setModeInfoMessage(message))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMessageCount(let count):
            newState.messageCount = count
        case .setButtonTabState(let tab):
            newState.tabState = tab

        case .setRecievedMessageList(let message):
            newState.recivedMessageList = message
        case .setSentMessageList(let message):
            newState.sentMessageList = message
        case .setMessageToast(let message):
            newState.toastMessage = message
        case .setModeInfoMessage(let message):
            newState.messageMode = message
        }
        return newState
    }
}

    //MARK: - MutationMethod

extension MessageStorageReactor {
    private func fetchMessageList(cursor: Int, type: String) -> Observable<Mutation> {
        let query = GetMessageRequest(cursorId: cursor, type: type)
        return usecase.getMessage(query: query)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                let messages = self.mapToMessageContentModel(response.messages)
                if type == "RECEIVED" {
                    return Observable.just(.setRecievedMessageList(messages))
                } else {
                    return Observable.just(.setSentMessageList(messages))
                }
            }
            .catch { error in
                print("❌ Error: \(error.localizedDescription)")
                return Observable.empty() // 오류를 무시하거나 빈 Observable로 대체
            }
    }
}

    //MARK: - HelperMethod

extension MessageStorageReactor {
    private func mapToMessageContentModel(_ messages: [ReceivedMessageEntity]) -> [MessageContentModel] {
        return messages.map { message in
            // studentInfo 예시: "WeSpot고등학교 3학년 7반"
            let studentInfo = "\(message.receiver.schoolName)\n\(message.receiver.grade)학년 \(message.receiver.classNumber)반 "
            let date = convertDate(message.receivedAt)
            return MessageContentModel(
                studentInfo: studentInfo,
                date: date,
                isRead: message.isRead,
                isBlocked: message.isBlocked,
                isReported: message.isReported,
                content: message.content,
                senderName: message.senderName,
                reciverName: message.receiver.name,
                messageId: message.id
            )
        }
    }
    
    private func convertDate(_ dateString: String) -> String {
        // 입력 포맷 지정 (밀리초 및 마이크로초까지 포함한 형식)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString // 변환에 실패할 경우 원본 문자열 반환
        }
        
        // 출력 포맷 지정
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy. MM. dd"
        return outputFormatter.string(from: date)
    }
}
