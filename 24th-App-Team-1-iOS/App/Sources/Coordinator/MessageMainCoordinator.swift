//
//  MessageMainCoordinator.swift
//  wespot
//
//  Created by 김도현 on 1/6/25.
//

import UIKit

import Util
import MessageFeature

public protocol MessageMainCoordinatorProtocol {
    func toMessageMain()
}

public final class MessageMainCoordinator: MessageMainCoordinatorProtocol, Coordinator {
    public var parent: (any Coordinator)?
    public var navigationController: UINavigationController
    public var childCoordinators: [any Coordinator] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    public func toMessageMain() {
        let messageMainViewController = MessageMainDIContainer().makeViewController()
        navigationController.pushViewController(messageMainViewController, animated: true)
    }
    
}
