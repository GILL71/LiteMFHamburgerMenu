//
//  MenuPresentationController.swift
//  LiteMFHamburgerMenu
//
//  Created by Michael Nechaev on 16/05/2018.
//  Copyright © 2018 Michael Nechaev. All rights reserved.
//

import UIKit

class MenuPresentationController: UIPresentationController, UIGestureRecognizerDelegate {
    
    var dimmingView: UIView!
    
    override func presentationTransitionWillBegin() {
        dimmingView = UIView(frame: containerView!.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        containerView?.addSubview(dimmingView)
        //
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        dimmingView.addGestureRecognizer(tap)
        dimmingView.isUserInteractionEnabled = true
        //
        let transitionCoordinator = presentingViewController.transitionCoordinator!
        
        dimmingView.alpha = 0
        transitionCoordinator.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
            dimmingView = nil
        }
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            dimmingView = nil
        }
    }
    
    //MARK: - Helper
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        print("handle tap!")
        presentedViewController.dismiss(animated: true) { [weak self] in
        }
    }
}
