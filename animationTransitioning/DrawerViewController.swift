//
//  DrawerViewController.swift
//  animationTransitioning
//
//  Created by abi01373 on 2020/06/01.
//  Copyright © 2020 abi01373. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {

     @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var modalContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        // ...
     }
    
    @objc private func onButtonTap() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
