//
//  UIMenuViewController.swift
//  LiteMFHamburgerMenu
//
//  Created by Michael Nechaev on 16/05/2018.
//  Copyright © 2018 Michael Nechaev. All rights reserved.
//

import UIKit

class UIMenuViewController: UIViewController {
    
    let delegate = MenuTransitioningDelegate()
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .custom
        transitioningDelegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panUp = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        panUp.delegate = self
        view.addGestureRecognizer(panUp)
    }
    
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = -translate.x / gesture.view!.bounds.size.height
        
        if gesture.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            delegate.interactionController = interactionController
            
            dismiss(animated: true)
        } else if gesture.state == .changed {
            interactionController?.update(percent)
        } else if gesture.state == .ended {
            let velocity = gesture.velocity(in: gesture.view)
            interactionController?.completionSpeed = 0.999
            if (percent > 0.5 && velocity.x <= 0) || velocity.x < 0 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
    func reloadContentViewController(id: String) {
        NotificationCenter.default.post(name: NSNotification.Name("reloadVC"),
                                        object: nil,
                                        userInfo: ["storyboardId": id])
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIMenuViewController: UIGestureRecognizerDelegate {
    //вычисляется угол для определения направления жеста
    //угол для свайпа справа налево: от 7пи/8 до пи (по модулю)
    //если бы нам нужен свайп слева направо: наш угол - до 0 (погрешность определяем по желанию)
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = pan.translation(in: pan.view)
            let angle = abs(atan2(translation.x, translation.y) - .pi / 2)
            //return angle < .pi / 8.0
            return angle >= 7.0 * .pi / 8.0
        }
        return false
    }
}
