//
//  AnonymousProfileBottomSheetRouter.swift
//  MessageFeature
//
//  Created by 최지철 on 4/15/25.
//

import UIKit

import MessageDomain

public protocol AnonymousProfileBottomSheetRouting {
    func presentAnonymousProfileBottomSheet(_ state: AnonymousProfileStatusEnum, vc: UIViewController, onProfileCreated: @escaping (_ name: String, _ imageUrl: String) -> Void)
    func dismissAnonymousProfileBottomSheet(vc: UIViewController)
    func presenSetImagetBottomSheet(vc: UIViewController)
    func popUpmakeAnonyProfile(vc: UIViewController, onProfileCreated: @escaping (_ name: String, _ imageUrl: String) -> Void)
    func goToWriteMessage(reactor: MessageWriteReactor, vc: UIViewController)

}
@available(iOS 16.0, *)
public class AnonymousProfileBottomSheetRouter: AnonymousProfileBottomSheetRouting {
    
    private let reactor: AnonymousProfileReactor
    public init(reactor: AnonymousProfileReactor) {
        self.reactor = reactor
    }
    
    public func presentAnonymousProfileBottomSheet(_ state: AnonymousProfileStatusEnum, vc: UIViewController, onProfileCreated: @escaping (String, String) -> Void) {
        Task { @MainActor in
            print(state)
            let bottomSheet = AnonymousProfileBottomSheetsViewController(status: state, reactor: reactor)
            bottomSheet.onProfileCreated = onProfileCreated
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
    
    public  func goToWriteMessage(reactor: MessageWriteReactor, vc: UIViewController) {
        print("goToWriteMessage")
        let vc = MessageWriteViewController(reactor: reactor)
        vc.navigationController?.pushViewController(vc,
                                                      animated: true)
    }
    
    public func presenSetImagetBottomSheet(vc: UIViewController) {
        Task { @MainActor in
            let bottomSheet = AnoymousProfileSetImageBottomSheet(reactor: reactor)
            bottomSheet.modalPresentationStyle = .pageSheet
            if let sheet = bottomSheet.sheetPresentationController {
                sheet.detents = [
                    .custom(identifier: .init("AnoymousProfileSetImageBottomSheet"), resolver: { context in
                        return 140
                    }),
                    .large()
                ]
                sheet.selectedDetentIdentifier = .init("AnoymousProfileSetImageBottomSheet")
                sheet.prefersGrabberVisible = true
            }
            vc.present(bottomSheet, animated: true, completion: nil)
        }
    }
    
    public func popUpmakeAnonyProfile(vc: UIViewController, onProfileCreated: @escaping (_ name: String, _ imageUrl: String) -> Void) {
        let popup = MakeAnonymousProfilePopupViewController()
        popup.reactor = reactor
        
        // ✨ 여기가 핵심! popupVC에 콜백 함수를 설정해줍니다.
        popup.onProfileCreated = onProfileCreated
        
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        vc.present(popup, animated: true)
    }

    public func dismissAnonymousProfileBottomSheet(vc: UIViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
}

