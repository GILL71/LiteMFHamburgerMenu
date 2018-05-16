//
//  ContainerViewController.swift
//  LiteMFHamburgerMenu
//
//  Created by Michael Nechaev on 16/05/2018.
//  Copyright © 2018 Michael Nechaev. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var currentViewController: UIViewController?
    var loadingViewController: UIViewController?
    
    let initialViewControllerId = "nav2"
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadVC"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadViewController),
                                               name: Notification.Name("reloadVC"),
                                               object: nil)
        let vc = self.loadViewController(with: initialViewControllerId)
        self.add(asChildViewController: vc)
        self.currentViewController = vc
    }
    
    @objc func reloadViewController(_ notification: Notification) {
        if let storyboardId = notification.userInfo?["storyboardId"] as? String {
            if let currentVc = self.currentViewController {
                self.remove(asChildViewController: currentVc)
            } else {
                print("error: no view controllers in hierarchy")
            }
            let loadingVc = self.loadViewController(with: storyboardId)
            add(asChildViewController: loadingVc)
            self.currentViewController = loadingVc
        }
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }

    private func loadViewController(with storyboardId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        return vc
    }
}
