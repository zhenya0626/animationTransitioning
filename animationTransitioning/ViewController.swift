//
//  ViewController.swift
//  animationTransitioning
//
//  Created by abi01373 on 2020/06/01.
//  Copyright © 2020 abi01373. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dimmingView = UIView()
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        // ...
    }

    @objc private func onButtonTap() {
        let drawerViewController = DrawerViewController()
        drawerViewController.modalPresentationStyle = .custom
        drawerViewController.transitioningDelegate = self
        
        present(drawerViewController, animated: true, completion: nil)
    }

}
extension ViewController:  UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
extension ViewController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Retrieve the view controllers participating in the current transition from the context.
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let toView = transitionContext.viewController(forKey: .to)!.view!

        // If the view to transition from is this controller's view, the drawer is being presented.
        let isPresentingDrawer = fromView == view
        
        let drawerView = isPresentingDrawer ? toView : fromView

        if isPresentingDrawer {
            // Any presented views must be part of the container view's hierarchy
            
            transitionContext.containerView.addSubview(dimmingView)
            dimmingView.frame = transitionContext.containerView.bounds
            dimmingView.alpha = 0.0
            dimmingView.backgroundColor = .black
            transitionContext.containerView.addSubview(drawerView)
        }
        

        /***** Animation *****/
        
        
        
        let drawerSize = CGSize(
            width: UIScreen.main.bounds.size.width * 0.8,
            height: UIScreen.main.bounds.size.height / 2)
        
        // Determine the drawer frame for both on and off screen positions.
        let offScreenDrawerFrame = CGRect(origin: CGPoint(x: transitionContext.containerView.bounds.width / 2, y:transitionContext.containerView.bounds.height / 2), size: CGSize(width: 0, height: 0))
        let onScreenDrawerFrame = CGRect(origin: CGPoint(x: transitionContext.containerView.bounds.width / 2 - drawerSize.width / 2, y: drawerSize.height / 2), size: drawerSize)
        
        let offScreenDrawerAlpha = 0.0
        let onScreenDrawerAlpha = 1.0
        
        let offScreenDrawerCorner = 30
        let onScreenDrawerCorner = 30
        
        // 遷移前の状態
        drawerView.frame = isPresentingDrawer ? offScreenDrawerFrame : onScreenDrawerFrame
        drawerView.alpha = CGFloat(isPresentingDrawer ? offScreenDrawerAlpha : onScreenDrawerAlpha)
        drawerView.layer.cornerRadius = CGFloat(isPresentingDrawer ? offScreenDrawerCorner : onScreenDrawerCorner)
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        // Animate the drawer sliding in and out.
        UIView.animate(withDuration: animationDuration, animations: {
            // 遷移後の状態
            drawerView.frame = isPresentingDrawer ? onScreenDrawerFrame : offScreenDrawerFrame
            drawerView.alpha = CGFloat(isPresentingDrawer ? onScreenDrawerAlpha : offScreenDrawerAlpha)
            drawerView.layer.cornerRadius = CGFloat(isPresentingDrawer ? onScreenDrawerCorner : offScreenDrawerCorner)
            self.dimmingView.alpha = 0.5
            
        }, completion: { (success) in
            // Cleanup view hierarchy
            if !isPresentingDrawer {
                drawerView.removeFromSuperview()
            }
            
            // IMPORTANT: Notify UIKit that the transition is complete.
            transitionContext.completeTransition(success)
        })
    }
}

