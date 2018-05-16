//
//  FirstViewController.swift
//  LiteMFHamburgerMenu
//
//  Created by Michael Nechaev on 16/05/2018.
//  Copyright © 2018 Michael Nechaev. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var interactionController: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = .left//.right
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = translate.x / gesture.view!.bounds.size.width//-translate.x / gesture.view!.bounds.size.width
        
        if gesture.state == .began {
            let controller = storyboard!.instantiateViewController(withIdentifier: "menu") as! MenuViewController
            interactionController = UIPercentDrivenInteractiveTransition()
            controller.delegate.interactionController = interactionController
            
            present(controller, animated: true)
        } else if gesture.state == .changed {
            interactionController?.update(percent)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            let velocity = gesture.velocity(in: gesture.view)
            interactionController?.completionSpeed = 0.999  // https://stackoverflow.com/a/42972283/1271826
            //            if (percent > 0.5 && velocity.x <= 0) || velocity.x < 0 {
            if (percent < 0.5 && velocity.x >= 0) || velocity.x > 0 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
}
