//
//  Coordinator.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/13.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import UIKit
public typealias CoordinatorManagedViewController = UIViewController & CoordinatorManaged

private struct AssociatedKey {
    static var coordinatorKey: String = "AssociatedKey.coordinator.key"
    static var rootViewControllerKey: String = "AssociatedKey.rootViewController.key"
}

/**
 The coordinator's protocol
 Conform this protocol by providing the rootViewController and the coordinator then could be presented by extension func present(:) and pop()
 */
public protocol Coordinator: AnyObject, WeakAssociatedObjectHolder {
    /// Weakly refer to the root view controller, could be nil before coordinator is built or prestented
    var rootViewController: CoordinatorManagedViewController? { get }
    
    /**
     Build and return the view controllers, note that DO NOT retain the returned view controller or navigation view controller in the coordinator.
     - Description: The returned view controller and navigation controller comes from the builder, defaultRootViewControoler() -> (CoordinatorManagedViewController, UINavigationController?), after injected the depedency of coordintors to the view controller
     
     */
    func buildRootViewControllers() -> (viewController: CoordinatorManagedViewController, navigationController: UINavigationController?)
    
    // MARK: Required functions
    
    /**
     Return the default view controller and it's navigation controller (if any), setup the dependency of the view controllers here.
     - Note: Do not call this method directly. Use buildModule instead.
     - Description: This is the builder method for setting up the module, such as initilization of dependecies and injection of dependencies.
     */
    func defaultRootViewController() -> (rootViewController: CoordinatorManagedViewController, navigationController: UINavigationController?)
}

public extension Coordinator {
    
    weak var rootViewController: CoordinatorManagedViewController? {
        set {
            let middle: UIViewController? = newValue
            setWeakAssociatedObject(key: &AssociatedKey.rootViewControllerKey, value: middle)
        }
        get {
            let middle: UIViewController? = getWeakAssociatedObject(key: &AssociatedKey.rootViewControllerKey)
            return middle as? CoordinatorManagedViewController
        }
    }
    
    func buildRootViewControllers() -> (viewController: CoordinatorManagedViewController, navigationController: UINavigationController?) {
        
        if let rootViewController = self.rootViewController {
            return (rootViewController, rootViewController.navigationController)
        }
        
        let (viewController, navigationController) = defaultRootViewController()
        assert(navigationController?.viewControllers.contains(viewController) ?? true, "The view controller should be in the stack of the navigation controller")
        
        self.rootViewController = viewController
        rootViewController?.coordinator = self
        
        return (viewController, navigationController)
    }
}

public protocol CoordinatorManaged: AnyObject {
    /// Handful property to refer the coordinator, note that this propery retains the coordinator
    var coordinator: Coordinator? { get set }
}

public extension CoordinatorManaged {
    var coordinator: Coordinator? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.coordinatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.coordinatorKey) as? Coordinator
        }
    }
}
