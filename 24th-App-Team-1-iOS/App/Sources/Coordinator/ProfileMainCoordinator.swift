//
//  ProfileMainCoordinator.swift
//  wespot
//
//  Created by 김도현 on 1/6/25.
//

import UIKit

import Util
import AllFeature

public protocol ProfileMainCoordinatorProtocol {
    func toProfile()
}


public final class ProfileMainCoordinator: ProfileMainCoordinatorProtocol, Coordinator {
    public var parent: (any Coordinator)?
    public var navigationController: UINavigationController
    public var childCoordinators: [any Coordinator] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func toProfile() {
        let profileMainViewController = ProfileMainDIContainer().makeViewController()
        navigationController.pushViewController(profileMainViewController, animated: true)
    }
}
