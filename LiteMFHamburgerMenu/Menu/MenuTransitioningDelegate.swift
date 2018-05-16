//
//  MenuTransitioningDelegate.swift
//  LiteMFHamburgerMenu
//
//  Created by Michael Nechaev on 16/05/2018.
//  Copyright © 2018 Michael Nechaev. All rights reserved.
//

import UIKit

class MenuTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    weak var interactionController: UIPercentDrivenInteractiveTransition?
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MenuPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuAnimatedTransitioning(transitionType: .presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuAnimatedTransitioning(transitionType: .dismissing)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}


