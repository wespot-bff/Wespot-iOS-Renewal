//
//  AppCoordinator.swift
//  wespot
//
//  Created by 김도현 on 12/20/24.
//

import UIKit

import Util
import LoginFeature

/// SceneDelegate에 호출되는 화면 전환 메서드의 청사진 입니다.
public protocol AppCoordinatorProtocol {
    func toSplash(accessToken: String?)
}


final class AppCoordinator: AppCoordinatorProtocol, Coordinator {
    weak var parent: (any Coordinator)?
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func toSplash(accessToken: String?) {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        childCoordinators.removeAll()
        splashCoordinator.parent = parent
        childCoordinators.append(splashCoordinator)
        splashCoordinator.toSplash(accessToken: accessToken)
        
    }
}

