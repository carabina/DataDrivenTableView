//
//  DDSection.swift
//  DataDrivenTableView
//
//  Created by mohsen shakiba on 9/6/1396 AP.
//

import Foundation

public enum UpdateResult<T> where T: Hashable {
    
    case prepend([T])
    case append([T])
    case reload(T)
    case delete(T)
    
    var isEmpty: Bool {
        var isEmpty = true
        switch self {
        case .prepend(let items):
            if items.count != 0 { isEmpty = false }
        case .append(let items):
            if items.count != 0 { isEmpty = false }
        case .reload(_):
            isEmpty = false
        case .delete(_):
            isEmpty = false
        }
        return isEmpty
    }
    
}

open class DDSection<T>: DDSectionProtocol where T: Hashable {
    
    public var index: Int?
    public var items: [T] = []
    public weak var tableView: UITableView!
    public var lastError: Error?
    public var refreshControl = UIRefreshControl()
    
    var lockForFetchMoreItems = false
    var isFetchInProgress = false
    
    open var isRefreshControlEnabled: Bool {
        return false
    }
    open var isInfiniteScrollEnabled: Bool {
        return false
    }
    
    /// initializer
    public init(items: [T]) {
        self.items = items
    }
    
    open func numberOfRows() -> Int {
        return items.count
    }
    
    open func shouldRequestForModeItems() -> Bool {
        return !lockForFetchMoreItems
    }
    
    open func update(result: UpdateResult<T>, animation: UITableViewRowAnimation? = nil) {
        isFetchInProgress = false
        endRefreshControlAnimation()
        if result.isEmpty {
            lockForFetchMoreItems = true
            hideInfiniteScrollLoading()
            return
        }
        guard let index = self.index else { return }
        guard let tableView = self.tableView else { return }
        switch result {
        case .prepend(let newItems):
            items.insert(contentsOf: newItems, at: 0)
            if let animation = animation {
                let indexPaths = (0..<newItems.count).map({IndexPath(item: $0, section: index)})
                tableView.insertRows(at: indexPaths, with: animation)
            }else{
                tableView.reloadData()
            }
        case .append(let newItems):
            items.append(contentsOf: newItems)
            if let animation = animation {
                let indexPaths = ((items.count - newItems.count)..<items.count).map({IndexPath(item: $0, section: index)})
                tableView.insertRows(at: indexPaths, with: animation)
            }else{
                tableView.reloadData()
            }
        case .reload(let item):
            if let itemIndex = self.index(of: item) {
                if let animation = animation {
                    let indexPath = IndexPath(item: itemIndex, section: index)
                    tableView.reloadRows(at: [indexPath], with: animation)
                }else{
                    tableView.reloadData()
                }
            }
        case .delete(let item):
            if let itemIndex = self.index(of: item) {
                items.remove(at: itemIndex)
                if let animation = animation {
                    let indexPath = IndexPath(item: itemIndex, section: index)
                    tableView.deleteRows(at: [indexPath], with: animation)
                }else{
                    tableView.reloadData()
                }
            }
        }
    }
    
    open func update(failed error: Error) {
        if items.count == 0 {
            
        }else{
            self.lastError = error
        }
    }
    
    open func index(of model: T) -> Int? {
        return items.index(of: model)
    }
    
    public func attachedToTableView(_ tableView: UITableView, index: Int) {
        self.index = index
        self.tableView = tableView
        candidateForNewFetchRequest()
        if isRefreshControlEnabled {
            if #available(iOS 10.0, *) {
                tableView.refreshControl = refreshControl
                refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
            }
        }
        registerCells()
    }
    
    func candidateForNewFetchRequest() {
        if isFetchInProgress { return }
        if lockForFetchMoreItems { return }
        showInfiniteScrollLoading()
        isFetchInProgress = true
        requestForMoreItems()
    }
    
    open func infiniteScrollView() -> UIView {
        fatalError()
    }
    
    open func hideInfiniteScrollLoading() {
        tableView?.tableFooterView = nil
    }
    
    open func showInfiniteScrollLoading() {
        if !isInfiniteScrollEnabled { return }
        if items.count == 0 { return }
        if tableView.contentSize.height < UIScreen.main.bounds.height { return }
        let footer = infiniteScrollView()
        tableView?.tableFooterView = footer
    }
    
    open func endRefreshControlAnimation() {
        refreshControl.endRefreshing()
    }
    
    
    /// MARK: - Register cells
    
    open func registerCells() {
        fatalError()
    }
    
    open func requestForMoreItems() {
        fatalError()
    }
    
    @objc open func didRefresh() {
        fatalError()
    }
    
    /// MARK: - UITableView delegate and datasource mthods

    open func heightForRow(at index: Int) -> CGFloat {
        fatalError()
    }
    
    open func cellForRow(at index: Int) -> UITableViewCell {
        fatalError()
    }
    
    /// return bool to indicate whether you want the cell to be deselected, default to true
    open func didSelectRow(at index: Int) -> Bool {
        return true
    }
    
    open func didDeselectRow(at index: Int) {
        
    }
    
    open func shouldHightlighRow(at index: Int) -> Bool {
        return false
    }
    
    open func didHighlightRow(at index: Int) {
        
    }
    
    open func didUnhighlightRow(at index: Int) {
        
    }
    
    open func willDisplayCell(at index: Int) {
        if index == (items.count - 1) {
            candidateForNewFetchRequest()
        }
    }
    
    public func titleForHeader() -> String? {
        return nil
    }
    
    public func titleForFooter() -> String? {
        return nil
    }
    
    public func viewForHeader() -> UIView? {
        return nil
    }
    
    public func viewForFooter() -> UIView? {
        return nil
    }
    
    public func heightForHeader() -> CGFloat? {
        return nil
    }
    
    public func heightForFooter() -> CGFloat? {
        return nil
    }

    public func didEndDisplayingCell(at index: Int) {
        
    }
    
    public func canEditRow(at index: Int) -> Bool {
        return false
    }
    
    public func canMoveRow(at index: Int) -> Bool {
        return false
    }
    
    public func editingActionsForRow(at index: Int) -> [UITableViewRowAction]? {
        return nil
    }
    
}



