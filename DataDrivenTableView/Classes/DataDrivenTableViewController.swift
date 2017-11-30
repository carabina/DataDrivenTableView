//
//  DataDrivenTableViewController.swift
//  DataDrivenTableView
//
//  Created by mohsen shakiba on 9/7/1396 AP.
//

import UIKit

open class DDTableViewController: UIViewController {
    
    /// the reference to ddTableView
    /// the value is nil before the viewDidLoad
    public var ddTableView: DDTableView!
    
    /// override the style of table view
    open var style: UITableViewStyle {
        return UITableViewStyle.grouped
    }
    
    var currentView: UIView!
    public var animationDuration: TimeInterval = 0.25
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        ddTableView = DDTableView(style: style)
        view.addSubview(ddTableView)
        ddTableView.frame = self.view.bounds
        ddTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        ddTableView.dataSource.ddTableViewController = self
        currentView = ddTableView
    }
    
    open func showEmptyView() {
    }
    
    open func showError() {
    }
    
    open func showLoading() {
    }
    
    open func showTableView() {
        animate(to: ddTableView)
    }
    
    public func animate(to view: UIView) {
        if currentView == view {
            return
        }
        attachToSuperView(view: view)
        UIView.transition(from: currentView, to: view, duration: self.animationDuration, options: [.curveLinear, .transitionCrossDissolve,. showHideTransitionViews]) { (_) in
            self.currentView = view
        }
    }
    
    /// this method can be overriden to configure the view before attaching to superView
    open func attachToSuperView(view: UIView) {
        view.isHidden = true
        self.view.addSubview(view)
        view.frame = self.view.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
