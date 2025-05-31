//
//  AnonymousProfileBottomSheetRouter.swift
//  MessageFeature
//
//  Created by 최지철 on 4/15/25.
//

import UIKit

import MessageDomain

public protocol AnonymousProfileBottomSheetRouting {
    func presentAnonymousProfileBottomSheet(_ state: AnonymousProfileStatusEnum, vc: UIViewController)
    func dismissAnonymousProfileBottomSheet(vc: UIViewController)
    func popUpmakeAnonyProfile(vc: UIViewController)
}
@available(iOS 16.0, *)
public class AnonymousProfileBottomSheetRouter: AnonymousProfileBottomSheetRouting {
    
    private let reactor: AnonymousProfileReactor
    public init(reactor: AnonymousProfileReactor) {
        self.reactor = reactor
    }
    
    public func presentAnonymousProfileBottomSheet(_ state: AnonymousProfileStatusEnum, vc: UIViewController) {
        Task { @MainActor in
            print(state)
            let bottomSheet = AnonymousProfileBottomSheetsViewController(status: state, reactor: reactor)
            bottomSheet.modalPresentationStyle = .pageSheet
            if let sheet = bottomSheet.sheetPresentationController {
                sheet.detents = [
                    .custom(identifier: .init("AnonymousProfileBottomSheet"), resolver: { context in
                        return state.totalHeight
                    }),
                    .large()
                ]
                sheet.selectedDetentIdentifier = .init("AnonymousProfileBottomSheet")
                sheet.prefersGrabberVisible = true
            }
            vc.present(bottomSheet, animated: true, completion: nil)
        }
    }
    
    public func popUpmakeAnonyProfile(vc: UIViewController) {
        let popup = MakeAnonymousProfilePopupViewController()
        popup.reactor = reactor
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        vc.present(popup, animated: true)
    }

    public func dismissAnonymousProfileBottomSheet(vc: UIViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
}

