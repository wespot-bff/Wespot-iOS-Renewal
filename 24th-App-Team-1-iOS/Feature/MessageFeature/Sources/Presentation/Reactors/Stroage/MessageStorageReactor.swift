//
//  MessageStorageReactor.swift
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

    // MARK: - State
    public struct State {
        var messageCount: Int = 0
        var tabState: MessageButtonTabEnum = .received
        @Pulse var recivedMessageList: [MessageContentModel] = []
        @Pulse var sentMessageList: [MessageContentModel] = []
        @Pulse var toastMessage: MessageContentModel?
        @Pulse var messageMode: MessageContentModel?
        
        // 페이징 관리: 현재 커서와 추가 데이터 여부
        @Pulse var cursorId: Int = 0
        @Pulse var hasNext: Bool = true
    }

    // MARK: - Action
    public enum Action {
        case loadMessages(type: String)              // 초기 데이터 로드
        case receivedMessageButtonTapped             // 받은 메시지 탭 전환
        case sentMessageButtonTapped                 // 보낸 메시지 탭 전환
        case toastMessageDetail(MessageContentModel) // 토스트 상세내용 표시 요청
        case moreButtonTapped(MessageContentModel)   // More 버튼 탭(추가 옵션) 요청
        case loadMoreMessages(type: String)          // 스크롤 하단 도달 시 추가 데이터 로드
    }

    // MARK: - Mutation
    public enum Mutation {
        case setMessageCount(Int)
        case setButtonTabState(MessageButtonTabEnum)
        case setRecievedMessageList([MessageContentModel])
        case appendRecievedMessageList([MessageContentModel])
        case setSentMessageList([MessageContentModel])
        case appendSentMessageList([MessageContentModel])
        case setMessageToast(MessageContentModel)
        case setModeInfoMessage(MessageContentModel)
        // 업데이트된 커서와 추가 데이터 여부를 state에 반영
        case updateCursor(Int, Bool)
    }

    public var initialState: State

    // MARK: - Initialization
    public init(usecase: MessageStorageUseCase) {
        self.usecase = usecase
        self.initialState = State()
    }

    // MARK: - Action -> Mutation
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .receivedMessageButtonTapped:
            // 탭 전환 시, state에 현재 탭을 업데이트
            return Observable.just(.setButtonTabState(.received))
        case .loadMessages(let type):
            // 초기 데이터 로드: 현재 cursor를 기준으로 API 호출
            return fetchMessageList(cursor: currentState.cursorId, type: type)
        case .sentMessageButtonTapped:
            return Observable.just(.setButtonTabState(.sent))
        case .loadMoreMessages(let type):
            // 추가 페이지 요청 (hasNext가 true일 경우에만 실행)
            guard currentState.hasNext else { return Observable.empty() }
            return fetchMessageList(cursor: currentState.cursorId, type: type, append: true)
        case .toastMessageDetail(let message):
            // 선택된 메시지의 상세 토스트 표시 요청
            return Observable.just(.setMessageToast(message))
        case .moreButtonTapped(let message):
            // More 버튼 탭 시, 추가 옵션 정보 전달
            return Observable.just(.setModeInfoMessage(message))
        }
    }

    // MARK: - Mutation -> State
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMessageCount(let count):
            newState.messageCount = count
        case .setButtonTabState(let tab):
            newState.tabState = tab
        case .setRecievedMessageList(let messages):
            newState.recivedMessageList = messages
        case .appendRecievedMessageList(let messages):
            newState.recivedMessageList += messages
        case .setSentMessageList(let messages):
            newState.sentMessageList = messages
        case .appendSentMessageList(let messages):
            newState.sentMessageList += messages
        case .setMessageToast(let message):
            newState.toastMessage = message
        case .setModeInfoMessage(let message):
            newState.messageMode = message
        case .updateCursor(let newCursor, let hasNext):
            newState.cursorId = newCursor
            newState.hasNext = hasNext
        }
        return newState
    }
}

extension MessageStorageReactor {
    /// API 호출 및 페이징 처리를 담당하는 함수입니다.
    /// - Parameters:
    ///   - cursor: 현재 요청할 커서 값 (페이지 번호 개념)
    ///   - type: "RECEIVED" 또는 "SENT"
    ///   - append: true이면 기존 목록에 추가, false이면 새로 설정
    /// - Returns: Mutation Observable, 목록 갱신과 커서 업데이트를 포함합니다.
    private func fetchMessageList(cursor: Int, type: String, append: Bool = false) -> Observable<Mutation> {
        let query = GetMessageRequest(cursorId: cursor, type: type)
        return usecase.getMessage(query: query)
            .asObservable()
            .flatMap { response -> Observable<Mutation> in
                let messages = self.mapToMessageContentModel(response.messages)
                let newCursor = response.lastCursorId
                let hasNext = response.hasNext

                let listMutation: Observable<Mutation>
                if type == "RECEIVED" {
                    // append 여부에 따라 Mutation 결정 (set vs. append)
                    listMutation = append ?
                        Observable.just(.appendRecievedMessageList(messages)) :
                        Observable.just(.setRecievedMessageList(messages))
                } else {
                    listMutation = append ?
                        Observable.just(.appendSentMessageList(messages)) :
                        Observable.just(.setSentMessageList(messages))
                }
                // merge 목록 갱신 Mutation과 커서 업데이트 Mutation
                return Observable.merge(
                    listMutation,
                    Observable.just(.updateCursor(newCursor, hasNext))
                )
            }
            .catch { error in
                print("❌ Error: \(error.localizedDescription)")
                return Observable.empty()
            }
    }
}

extension MessageStorageReactor {
    /// 메시지 엔티티를 MessageContentModel로 매핑하는 함수입니다.
    private func mapToMessageContentModel(_ messages: [ReceivedMessageEntity]) -> [MessageContentModel] {
        return messages.map { message in
            let studentInfo = "\(message.receiver.schoolName)\n\(message.receiver.grade)학년 \(message.receiver.classNumber)반"
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
    
    /// API의 날짜 문자열을 "yyyy. MM. dd" 형식으로 변환합니다.
    private func convertDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy. MM. dd"
        return outputFormatter.string(from: date)
    }
}
