//
//  AbstractContainer.swift
//  Sweedate
//
//  Created by VLADIMIR KONEV on 28.01.16.
//  Copyright © 2016 Sweedate. All rights reserved.
//

import UIKit

/// Type of container enumerations
public enum AnimationType{
    /// Animates container with dissolve effect
    case Dissolve
    
    /// Animates container with sliding effect, where container will be above current controller
    case SlideAbove
    
    /// Animates container with sliding effect, where container will be below current controller
    case SlideBelow
    
    /// Animates container with sliding effect, where container will be above current controller. Not implemented.
    case Scale // Not implemented
}

public class AbstractContainer: UIViewController{
    // MARK: Menu properties
    private (set) var isMenuVisible: Bool = true
    private (set) var contentNavigationController: UINavigationController? = nil
    @IBOutlet var container: UIView!
    
    
    // MARK: Menu animation params
    public var toggleDuration: NSTimeInterval = 0.15
    public var toggleOptions: UIViewAnimationOptions = UIViewAnimationOptions.CurveEaseInOut
    public var toggleOffsetConstant: CGFloat = 30.0
    public var toggleAnimationType: AnimationType = .Dissolve // Default animation form is dissolve
    
    // MARK: Internal properties
    private var _darkOverlayView: UIView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Add dark overlay
        _darkOverlayView = UIView(frame: self.view.bounds)
        _darkOverlayView.backgroundColor = UIColor(colorLiteralRed: 9.0/255, green: 27.0/255, blue: 46.0/255, alpha: 0.5)
        self.view.addSubview(_darkOverlayView)
        self.view.sendSubviewToBack(_darkOverlayView)
        
        // Add gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "toggleSideMenu")
        tapGestureRecognizer.numberOfTapsRequired = 1
        _darkOverlayView.addGestureRecognizer(tapGestureRecognizer)
        
        // Add container to subviews if not on stack
        if container == nil{
            container = UIView(frame: self.view.bounds)
        }
        
        // Hack to drop every constraint to parent of container
        container.removeFromSuperview()
        container.frame = self.view.bounds
        container.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        container.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(container)
        
        // Present menu
        animateMenuShow()
    }
    
    // MARK: Menu manipulation
    public var menuItems: [MenuItem] = [MenuItem]()
    public func addMenuItem(item: MenuItem){
        menuItems.append(item)
    }
    
    public func removeAllItems(){
        menuItems.removeAll()
    }
    
    public func menuItemForSegue(segueIdentifier: String) -> MenuItem?{
        let filteredItems = menuItems.filter{$0.segueIdentifier == segueIdentifier}
        return filteredItems.first
    }
}


// MARK: Containment logic
extension AbstractContainer{
    private func prepareContentController(controller: UIViewController) -> UINavigationController{
        var result: UINavigationController
        
        // Check already required class
        if let exist_nvc = controller as? UINavigationController{
            result = exist_nvc
        }else{
            result = UINavigationController(rootViewController: controller)
        }
        
        // Prepare menu toggle bar button item
        let bundle = NSBundle(forClass: AbstractContainer.self)
        let image = UIImage(named: "side_menu_icon", inBundle: bundle, compatibleWithTraitCollection: nil)
        let toggleMenuItem = UIBarButtonItem(
            image: image,
            style: .Plain,
            target: self,
            action: "toggleSideMenu"
        )
        result.topViewController?.navigationItem.leftBarButtonItem = toggleMenuItem
        
        return result
    }
    
    public func pushController(target: UIViewController){
        // If switching to current controller - do nothing
        if target === contentNavigationController || target === contentNavigationController?.viewControllers.first {
            animateMenuHide()
            return
        }
        
        // If current not nil - remove from parent-child relationship
        if let currentNVC = self.contentNavigationController{
            currentNVC.willMoveToParentViewController(nil)
            currentNVC.popToRootViewControllerAnimated(false)
            currentNVC.view.removeFromSuperview()
            currentNVC.removeFromParentViewController()
        }
        
        // Add parent-child relationship to new controller
        let targetNVC = prepareContentController(target)
        self.addChildViewController(targetNVC)
        self.view.addSubview(targetNVC.view)
        targetNVC.view.frame = self.view.bounds
        targetNVC.didMoveToParentViewController(self)
        
        self.contentNavigationController = targetNVC
        animateMenuHide()
    }
    
    public func pushControllerOnStack(target: UIViewController){
        contentNavigationController?.pushViewController(target, animated: true)
        animateMenuHide()
    }
}

// MARK: Animation logic
extension AbstractContainer{
    internal func toggleSideMenu(){
        if isMenuVisible{
            animateMenuHide()
        }else{
            animateMenuShow()
        }
    }
    
    internal func animateMenuShow(){
        isMenuVisible = true
        
        switch toggleAnimationType{
        case .Dissolve:
            animate_dissolveShow()
        case .SlideAbove:
            animate_slideAboveShow()
        case .SlideBelow:
            animate_slideBelowShow()
        default:
            print("Show animation for type=\(toggleAnimationType) not implemented")
        }
    }
    
    internal func animateMenuHide(){
        isMenuVisible = false
        
        switch toggleAnimationType{
        case .Dissolve:
            animate_dissolveHide()
        case .SlideAbove:
            animate_slideAboveHide()
        case .SlideBelow:
            animate_slideBelowHide()
        default:
            print("Hide animation for type=\(toggleAnimationType) not implemented")
        }
    }
}

// MARK: Dissolve animation
extension AbstractContainer{
    private func animate_dissolvePrepare() {
        // Order Z pozitions - in dissolve proper order: content, overlay, container
        self.view.bringSubviewToFront(_darkOverlayView)
        self.view.bringSubviewToFront(container)
        
        // Container shadows - do not required in dissolve
        container.layer.shadowColor = UIColor.clearColor().CGColor
        container.layer.shadowOpacity = 0.0
        container.layer.shadowRadius = 0.0
        
        // Content shadows - do not required in dissolve
        if let content = contentNavigationController?.view{
            content.layer.shadowColor = UIColor.clearColor().CGColor
            content.layer.shadowOpacity = 0.0
            content.layer.shadowRadius = 0.0
        }
        
        // Specific animation prepares
        contentNavigationController?.view.frame = self.view.bounds
        container.frame = CGRectInset(self.view.bounds, toggleOffsetConstant, toggleOffsetConstant)
        container.hidden = false
        _darkOverlayView.hidden = false
    }
    
    private func animate_dissolveShow(){
        animate_dissolvePrepare()
        
        container.alpha = 0.0
        _darkOverlayView.alpha = 0.0
        
        UIView.animateWithDuration(
            toggleDuration,
            delay: 0.0,
            options: toggleOptions,
            animations: { () -> Void in
                self.container.alpha = 1.0
                self._darkOverlayView.alpha = 1.0
            }, completion: nil)
    }
    
    private func animate_dissolveHide(){
        animate_dissolvePrepare()
        
        UIView.animateWithDuration(
            toggleDuration,
            delay: 0.0,
            options: toggleOptions,
            animations: { () -> Void in
                self.container.alpha = 0.0
                self._darkOverlayView.alpha = 0.0
            }) { (_) -> Void in
                self.container.hidden = true
                self._darkOverlayView.hidden = true
        }
    }
}

// MARK: SlideAbove animation
extension AbstractContainer{
    private func animate_slideAbovePrepare(){
        // Order Z pozitions - in slideAbove proper order: content, overlay, container
        self.view.bringSubviewToFront(_darkOverlayView)
        self.view.bringSubviewToFront(container)
        
        // Container shadows - required in slideAbove
        container.layer.shadowColor = UIColor.blackColor().CGColor
        container.layer.shadowOpacity = 0.5
        container.layer.shadowRadius = 10.0
        
        // Content shadows - do not required in slideAbove
        if let content = contentNavigationController?.view{
            content.layer.shadowColor = UIColor.clearColor().CGColor
            content.layer.shadowOpacity = 0.0
            content.layer.shadowRadius = 0.0
        }
        
        // Specific animation prepares
        contentNavigationController?.view.frame = self.view.bounds // Stay on fixed position
        container.hidden = false
        _darkOverlayView.hidden = false
    }
    
    private func animate_slideAboveShow(){
        animate_slideAbovePrepare()
        
        let onScreenFrame = CGRect(x: 0.0, y: 0.0, width: toggleOffsetConstant, height: self.view.bounds.height)
        let offScreenFrame = CGRectOffset(onScreenFrame, -toggleOffsetConstant, 0.0)
        container.frame = offScreenFrame
        _darkOverlayView.alpha = 0.0
        
        UIView.animateWithDuration(
            toggleDuration,
            delay: 0.0,
            options: toggleOptions,
            animations: { () -> Void in
                self.container.frame = onScreenFrame
                self._darkOverlayView.alpha = 1.0
            }, completion: nil)
    }
    
    private func animate_slideAboveHide(){
        animate_slideAbovePrepare()
        
        let onScreenFrame = CGRect(x: 0.0, y: 0.0, width: toggleOffsetConstant, height: self.view.bounds.height)
        let offScreenFrame = CGRectOffset(onScreenFrame, -toggleOffsetConstant, 0.0)
        container.frame = onScreenFrame
        _darkOverlayView.alpha = 1.0

        UIView.animateWithDuration(
            toggleDuration,
            delay: 0.0,
            options: toggleOptions,
            animations: { () -> Void in
                self.container.frame = offScreenFrame
                self._darkOverlayView.alpha = 0.0
            }) { (_) -> Void in
                self.container.hidden = true
                self._darkOverlayView.hidden = true
        }
    }
}

// MARK: SlideBelow animation
extension AbstractContainer{
    private func animate_slideBelowPrepare(){
        // Order Z pozitions - in slideBelow proper order: overlay (hidden), containet, content 
        self.view.sendSubviewToBack(_darkOverlayView)
        self.view.sendSubviewToBack(container)
        
        
        // Container shadows - do not required in slideBelow
        container.layer.shadowColor = UIColor.clearColor().CGColor
        container.layer.shadowOpacity = 0.0
        container.layer.shadowRadius = 0.0
        
        // Content shadows - required in slideBelow
        if let content = contentNavigationController?.view{
            content.layer.shadowColor = UIColor.blackColor().CGColor
            content.layer.shadowOpacity = 0.5
            content.layer.shadowRadius = 10.0
        }
        
        // Specific animation prepares
        container.frame = CGRect(x: 0.0, y: 0.0, width: toggleOffsetConstant, height: self.view.bounds.height) // stay on fixed position
        container.hidden = false
        _darkOverlayView.hidden = true
    }
    
    private func animate_slideBelowShow(){
        animate_slideBelowPrepare()
        
        let onScreenFrame = self.view.bounds
        let offScreenFrame = CGRectOffset(onScreenFrame, toggleOffsetConstant, 0.0)
        contentNavigationController?.view.frame = onScreenFrame
        
        UIView.animateWithDuration(
            toggleDuration,
            delay: 0.0,
            options: toggleOptions,
            animations: { () -> Void in
                self.contentNavigationController?.view.frame = offScreenFrame
            }, completion: nil)
    }
    
    private func animate_slideBelowHide(){
        animate_slideBelowPrepare()
        
        let onScreenFrame = self.view.bounds
        let offScreenFrame = CGRectOffset(onScreenFrame, toggleOffsetConstant, 0.0)
        contentNavigationController?.view.frame = offScreenFrame
        
        UIView.animateWithDuration(
            toggleDuration,
            delay: 0.0,
            options: toggleOptions,
            animations: { () -> Void in
                self.contentNavigationController?.view.frame = onScreenFrame
            }){ (_) -> Void in
                self.container.hidden = true
        }
    }
}


class SideMenuSegue: UIStoryboardSegue{
    override func perform() {
        guard let svc = sourceViewController as? AbstractContainer else{
            return
        }
        svc.pushController(destinationViewController)
    }
}

class SideMenuStackSegue: UIStoryboardSegue{
    override func perform() {
        guard let svc = sourceViewController as? AbstractContainer else{
            return
        }
        svc.pushControllerOnStack(destinationViewController)
    }
}
