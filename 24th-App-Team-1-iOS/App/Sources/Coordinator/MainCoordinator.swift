//
//  MainCoordinator.swift
//  wespot
//
//  Created by 김도현 on 12/30/24.
//

import UIKit

import Util
import DesignSystem

public protocol MainCoordinatorProtocol {
    
}

public final class MainCoordinator: MainCoordinatorProtocol, Coordinator {
    public weak var parent: Coordinator?
    public var navigationController: UINavigationController
    public var childCoordinators: [any Coordinator] = []
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    public func toMain() {
        let tabbarController = WSTabBarViewController()
        let voteNavigationController = UINavigationController()
        let messageNavigationController = UINavigationController()
        let profileNavigationController = UINavigationController()
        
        toVoteMain(voteNavigationController, from: parent)
        toMessageMain(messageNavigationController, from: parent)
        toProfileMain(profileNavigationController, from: parent)
        
        tabbarController.viewControllers = [voteNavigationController, messageNavigationController, profileNavigationController]
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(tabbarController, animated: true)
        print("call main setup or \(navigationController) tabbar: \(tabbarController)")
        navigationController.isNavigationBarHidden = true
        
    }
    
}


private extension MainCoordinator {
    func toVoteMain(_ navigationController: UINavigationController, from parent: Coordinator?) {
        let voteMainCoordinator = VoteCoordinator(navigationController: navigationController)
        voteMainCoordinator.parent = parent
        parent?.childCoordinators.append(voteMainCoordinator)
        voteMainCoordinator.toMain()
    }
    
    func toMessageMain(_ navigationController: UINavigationController, from parent: Coordinator?) {
        let messageMainCoordinator = MessageMainCoordinator(navigationController: navigationController)
        messageMainCoordinator.parent = parent
        parent?.childCoordinators.append(messageMainCoordinator)
        messageMainCoordinator.toMessageMain()
    }
    
    func toProfileMain(_ navigationController: UINavigationController, from parent: Coordinator?) {
        let profileCoordinator = ProfileMainCoordinator(navigationController: navigationController)
        profileCoordinator.parent = parent
        parent?.childCoordinators.append(profileCoordinator)
        profileCoordinator.toProfile()
    }
}
