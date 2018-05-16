//
//  MenuViewController.swift
//  LiteMFHamburgerMenu
//
//  Created by Michael Nechaev on 16/05/2018.
//  Copyright © 2018 Michael Nechaev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTableView: UITableView!
    let delegate = MenuTransitioningDelegate()
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    //по-хорошему надо чтобы юзер имел доступ только к этим полям
    var itemsArray: [(storyboardId: String, tabLabelName: String)] = [("nav1", "First"),("nav2", "Second"),("nav3", "Third")]
    var menuHeaderText = "LiteMF Menu"
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = self.itemsArray[indexPath.row].1
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.reloadContentViewController(id: self.itemsArray[indexPath.row].0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        view.backgroundColor = tableView.backgroundColor
        let label = UILabel(frame: CGRect(x: 16, y: 20, width: view.frame.width - 16, height: 16))
        label.textColor = UIColor.white
        label.text = self.menuHeaderText
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        view.backgroundColor = tableView.backgroundColor
        return view
    }
    
    func reloadContentViewController(id: String) {
        NotificationCenter.default.post(name: NSNotification.Name("reloadVC"),
                                        object: nil,
                                        userInfo: ["storyboardId": id])
        self.dismiss(animated: true, completion: nil)
    }
}

extension MenuViewController: UIGestureRecognizerDelegate {
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
}


