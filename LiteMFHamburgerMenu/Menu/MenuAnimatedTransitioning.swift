//
//  MenuAnimatedTransitioning.swift
//  LiteMFHamburgerMenu
//
//  Created by Michael Nechaev on 16/05/2018.
//  Copyright © 2018 Michael Nechaev. All rights reserved.
//

import UIKit

class MenuAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate {
    
    enum TransitionType {
        case presenting
        case dismissing
    }
    
    let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView   = transitionContext.containerView
        let toView   = transitionContext.viewController(forKey: .to)!.view!
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        
        let frame = inView.bounds
        
        var offToLeft = frame
        offToLeft.origin.x -= 0.4 * frame.size.width
        offToLeft.size.width *= 0.4
        
        switch transitionType {
        case .presenting:
            //toView.frame = offToLeft
            
            toView.frame = CGRect(x: -165, y: 0, width: 165, height: frame.height)
            
            
            inView.addSubview(toView)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                
                
                toView.frame = CGRect(x: 0, y: 0, width: 165, height: frame.height)
                //но fromView мы должны передвинуть на новую позицию
                fromView.frame = CGRect(x: 165, y: 0, width: frame.width, height: frame.height)
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        case .dismissing:
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                //                fromView.frame = offToRight
                //fromView.frame = offToLeft
                fromView.frame = CGRect(x: -165, y: 0, width: 165, height: frame.height)
                //
                toView.frame = CGRect(x: 0, y: 0, width: inView.frame.width, height: inView.frame.height)
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
