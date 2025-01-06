//
//  VoteCoordinator.swift
//  wespot
//
//  Created by 김도현 on 1/3/25.
//

import UIKit

import Util
import VoteFeature




public final class VoteCoordinator: VoteCoordinatorProtocol, Coordinator {
    public var parent: Coordinator?
    public var navigationController: UINavigationController
    public var childCoordinators: [any Coordinator] = []
    
    public init(navigationController: UINavigationController, childCoordinators: [any Coordinator] = []) {
        self.navigationController = navigationController
        self.childCoordinators = childCoordinators
    }
    
    public func toMain() {
        let voteMainViewController = VoteMainDIContainer().makeViewController()
        
        navigationController.pushViewController(voteMainViewController, animated: true)
    }
    
    
}
