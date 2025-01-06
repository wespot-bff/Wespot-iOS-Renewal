//
//  SplashCoordinator.swift
//  wespot
//
//  Created by 김도현 on 1/3/25.
//

import UIKit

import Util
import SplashFeature



public final class SplashCoordinator: Coordinator, SplashCoordinatorProtocol {
    public weak var parent: Coordinator?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func toMain() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        childCoordinators.removeAll()
        mainCoordinator.parent = self
        
        print("splash Main go")
        mainCoordinator.toMain()
    }
    
    public func toLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.removeAll()
        loginCoordinator.parent = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.toSignIn()
    }
    
    public func toSplash(accessToken: String?) {
        let splashContainer = SplashDIContainer(accessToken: accessToken)
        let splashReactor = splashContainer.makeReactor()
        let splashViewController = splashContainer.makeViewController()
        
        splashReactor.splashCoordinator = self
        navigationController.pushViewController(splashViewController, animated: true)
    }
    
}
