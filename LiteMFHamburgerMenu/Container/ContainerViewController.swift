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
    
    @IBInspectable var initialId: String? //= "nav2"
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadVC"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadViewController),
                                               name: Notification.Name("reloadVC"),
                                               object: nil)
        if let id = self.initialId {
            let vc = self.loadViewController(with: id)
            self.add(asChildViewController: vc)
            self.currentViewController = vc
        } else {
            print("Error: set 'initialId' property in your ContainerViewController in .storyboard")
        }
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
        viewController.willMove(toParentViewController: nil)
        
        viewController.view.removeFromSuperview()
        
        viewController.removeFromParentViewController()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParentViewController: self)
    }

    private func loadViewController(with storyboardId: String) -> UIViewController {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: storyboardId) else {
            print("Error: no view controllers with storyboard id '\(storyboardId)'")
            return self
        }
        return vc
    }
}
