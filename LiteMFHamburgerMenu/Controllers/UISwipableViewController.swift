//
//  UISwipableViewController.swift
//  LiteMFHamburgerMenu
//
//  Created by Michael Nechaev on 16/05/2018.
//  Copyright © 2018 Michael Nechaev. All rights reserved.
//

import UIKit

class UISwipableViewController: UIViewController {
    var interactionController: UIPercentDrivenInteractiveTransition?
    @IBInspectable var menuId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = translate.x / gesture.view!.bounds.size.width
        
        if gesture.state == .began {
            let controller = storyboard!.instantiateViewController(withIdentifier: "menu_id") as! UIMenuViewController
            interactionController = UIPercentDrivenInteractiveTransition()
            controller.delegate.interactionController = interactionController
            
            present(controller, animated: true)
        } else if gesture.state == .changed {
            interactionController?.update(percent)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            let velocity = gesture.velocity(in: gesture.view)
            interactionController?.completionSpeed = 0.999
            if (percent < 0.5 && velocity.x >= 0) || velocity.x > 0 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
}
