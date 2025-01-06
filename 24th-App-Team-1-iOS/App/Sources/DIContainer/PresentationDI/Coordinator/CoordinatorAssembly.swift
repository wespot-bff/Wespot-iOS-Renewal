//
//  CoordinatorAssembly.swift
//  wespot
//
//  Created by 김도현 on 12/20/24.
//

import UIKit

import Swinject
import Util

/// 모든 Coordinator의 의존성을 등록하는 `Assembly` 입니다.
struct CoordinatorAssembly: Assembly {
    
    func assemble(container: Container) {
        /// AppCoordinator 의존성
        container.register(AppCoordinatorProtocol.self) { _ in
            return AppCoordinator(navigationController: UINavigationController())
        }
        
        container.register(SplashCoordinatorProtocol.self) { _ in
            return SplashCoordinator(navigationController: UINavigationController())
        }
        
        /// LoginCoordinator 의존성
        container.register(LoginCoordinatorProtocol.self) { _ in
            return LoginCoordinator(navigationController: UINavigationController())
        }
        
        container.register(VoteCoordinatorProtocol.self) { _ in
            return VoteCoordinator(navigationController: UINavigationController())
        }
    }
    
}
