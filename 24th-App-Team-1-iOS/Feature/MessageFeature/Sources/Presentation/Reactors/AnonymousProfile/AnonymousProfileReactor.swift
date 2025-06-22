//
//  AnonymousProfileReactor.swift
//  MessageFeature
//
//  Created by 최지철 on 4/13/25.
//

import MessageDomain
import Extensions
import Util
import DesignSystem
import CommonDomain

import ReactorKit
import RxSwift
import UIKit

public final class AnonymousProfileReactor: Reactor {
    
    // MARK: - UseCase
    
    private let usecase: AnonymousProfileUseCase
    private let imageUrlUsecase: CreatePresigendURLUseCaseProtocol
    public var router: AnonymousProfileBottomSheetRouting?

    // MARK: - Properties
    
    public var initialState: State
    
    public struct State {
        @Pulse var profileList: [AnonymousProfileEntity] = []
        @Pulse var isFull: Bool = false
        @Pulse var error: String = ""
        var userName: String = ""
        var profileImageURL: String = ""
        var profileImage: UIImage = DesignSystemAsset.Images.icBasicProfile.image
        var setProfileImageBottomSheet: [SetAnonymousProfileImageEnum] = [.setGalleryImage, .setBasicProfileImage]
        @Pulse var creationComplete: (name: String, imageUrl: String)?
    }
    
    public enum Action {
        case inputUserName(String)
        case presentMakeProfilePopup(vc: UIViewController, onProfileCreated: (String, String) -> Void)
        case selectedProfile
        case fetchProfileList
        case setImageTapped(UIViewController)
        case setProfileImage(UIImage)
        case uploadProfile
    }

    public enum Mutation {
        case setProfileList([AnonymousProfileEntity])
        case setError(String)
        case setImage(UIImage)
        case setUserName(String)
        case setProfileImageURL(String)
        case setCreationComplete(name: String, imageUrl: String)

    }
    
    // MARK: - Init
    
    public init(usecase: AnonymousProfileUseCase,
                imageUrlUsecase: CreatePresigendURLUseCaseProtocol,
                router: AnonymousProfileBottomSheetRouting?) {
        self.usecase = usecase
        self.imageUrlUsecase = imageUrlUsecase
        self.router = router
        self.initialState = State()
        print("AnonymousProfileReactor initialized")
        self.action.onNext(.fetchProfileList)
    }
}

    // MARK: - Reactor

extension AnonymousProfileReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
    
        case .presentMakeProfilePopup(let vc, let onProfileCreated):
            // Router를 호출하여 콜백을 그대로 전달한다.
            router?.popUpmakeAnonyProfile(vc: vc, onProfileCreated: onProfileCreated)
            return .empty()
        case .selectedProfile:
            return Observable.empty()

        case .fetchProfileList:
            return getProfileList()
        case .setImageTapped(let vc):
            router?.presenSetImagetBottomSheet(vc: vc)
            return Observable.empty()
        case .setProfileImage(let profileImage):
            let query = CreateProfilePresignedURLQuery(imageExtension: "jpeg")
            return imageUrlUsecase.execute(query: query)
                .asObservable()
                .withUnretained(self)
                .flatMap { owner, presignedInfo -> Observable<Mutation> in
                    guard let entity = presignedInfo else {
                        return .empty()
                    }
                    
                    return Observable.just(.setProfileImageURL(entity.presignedURL))
                }
        case .inputUserName(let text):
            return Observable.just(Mutation.setUserName(text))
        case .uploadProfile:
            return Observable.empty()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setProfileList(let list):
            print("AnonymousProfileList: \(list)")
            newState.profileList = list
        case .setError(let error):
            newState.error = error
        case .setImage(let image):
            newState.profileImage = image
        case .setUserName(let name):
            newState.userName = name
        case .setProfileImageURL(let url):
            newState.profileImageURL = url
        case .setCreationComplete(name: let name, imageUrl: let imageUrl):
            newState.creationComplete = (name, imageUrl)
        }
        return newState
    }
}


    // MARK: - Mutation Logic

extension AnonymousProfileReactor {
    private func getProfileList() -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            Task {
                do {
                    let entity = try await self.usecase.getAnonymousProfileList(receiverId: 0)
                    observer.onNext(Mutation.setProfileList(entity))
                } catch {
                    observer.onNext(Mutation.setError(error.localizedDescription))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

 
