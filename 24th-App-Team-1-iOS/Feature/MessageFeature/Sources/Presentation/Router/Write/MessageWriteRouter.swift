//
//  MessageWriteRouter.swift
//  MessageFeature
//
//  Created by 최지철 on 6/22/25.
//

import UIKit

import MessageDomain

public protocol MessageWriteRouting {
    func goToWriteMessage(reactor: MessageWriteReactor, vc: UIViewController)
}
public class MessageWriteRouter: MessageWriteRouting {
    
    public  func goToWriteMessage(reactor: MessageWriteReactor, vc: UIViewController) {
        let vc = MessageWriteViewController(reactor: reactor)
        vc.navigationController?.pushViewController(vc,
                                                      animated: true)
    }
    
    public init() {
        
    }
}
