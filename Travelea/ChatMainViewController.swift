//
//  ChatMainViewController.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/23/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Firebase

class ChatMainViewController: UIViewController {

    @IBOutlet weak var principalView: UIView!
    @IBOutlet weak var selectorTab: UISegmentedControl!
    var channels: Channel!
    var channelRef: DatabaseReference!
     weak var currentViewController: UIViewController?
    
    lazy var tableroVC: UIViewController? = {
        let tableroVC = self.storyboard?.instantiateViewController(withIdentifier: "TableroViewController") as? TableroViewController
        tableroVC?.channelRef = self.channelRef
        return tableroVC
    }()
    lazy var chatVc : UIViewController? = {
        let chatVc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        chatVc?.channelRef = self.channelRef
        chatVc?.channel = self.channels
        return chatVc
    }()
    lazy var notasVc : UIViewController? = {
        let notasVc = self.storyboard?.instantiateViewController(withIdentifier: "NotasViewController") as? NotasViewController
        notasVc?.channelRef = self.channelRef
        return notasVc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = channels.name
        self.navigationController?.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: "11A791")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.selectorTab.selectedSegmentIndex = 1
        self.updateView(forSegment: 1)

    }

    func updateView(forSegment index: Int){
        if let vc = viewControllerForSelectedSegmentIndex(index) {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            vc.view.frame = self.principalView.bounds
            self.principalView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    @IBAction func changeTab(_ sender: Any) {
        self.currentViewController?.view.removeFromSuperview()
        self.currentViewController?.removeFromParentViewController()
        self.updateView(forSegment: self.selectorTab.selectedSegmentIndex)
    }
    
    private func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case 0 :
            vc = tableroVC
        case 1 :
            vc = chatVc
        default:
            vc = notasVc
        }
        return vc
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
}
