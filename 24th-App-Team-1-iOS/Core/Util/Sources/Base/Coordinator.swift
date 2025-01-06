//
//  Coordinator.swift
//  Util
//
//  Created by 김도현 on 12/20/24.
//

import UIKit

import Swinject

/// 공통으로 사용하는 Coordinator Protocol 입니다.
public protocol Coordinator: AnyObject {
    var parent: Coordinator? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
}


///TODO; 별도 모듈에 코드 이전
public protocol SplashCoordinatorProtocol {
    func toMain()
    func toLogin()
    func toSplash(accessToken: String?)
}

public protocol VoteCoordinatorProtocol {
    func toMain()
}
