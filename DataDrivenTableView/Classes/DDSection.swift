//
//  DDSection.swift
//  DataDrivenTableView
//
//  Created by mohsen shakiba on 9/6/1396 AP.
//

import Foundation

open class DDSection<T>: DDSectionProtocol where T: Hashable {
    
    /// the index of section in table view
    /// in case of nil means it hasn't beed added
    /// in case of -1 means it was removed
    public var index: Int?
    
    /// array to store items
    public private(set) var items: [T] = []
    
    /// weak reference to table view
    public weak var tableView: UITableView!
    
    weak var ddTableViewContoller: DDTableViewController?
    
    /// last error, use to detect if the last update resulted in error
    public var lastError: Error?
    
    /// refresh control for the table view
    public var refreshControl: UIRefreshControl?
    
    /// is true, blocks subsequent requests
    var isFetchInProgress = false
    
    /// override to enable refresh control
    open var isRefreshControlEnabled: Bool {
        return false
    }
    
    /// override to enable infinite scrol
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
    
    open func update(insert newItems: [T], at: Int, animation: UITableViewRowAnimation? = nil) {
        guard let index = self.index else { return }
        guard let tableView = self.tableView else { return }
        processNextUpdate()
        if newItems.isEmpty {
            sendEmptyDatasourceSignal(appendedItemsCount: newItems.count)
            hideInfiniteScrollLoading()
            return
        }
        items.insert(contentsOf: newItems, at: index)
        if let animation = animation {
            let indexPaths = (0..<newItems.count).map({IndexPath(item: $0, section: index)})
            tableView.insertRows(at: indexPaths, with: animation)
        }else{
            tableView.reloadData()
        }
        sendTableViewSignal()
    }
    
    open func update(append newItems: [T], animation: UITableViewRowAnimation? = nil) {
        guard let index = self.index else { return }
        guard let tableView = self.tableView else { return }
        processNextUpdate()
        if newItems.isEmpty {
            sendEmptyDatasourceSignal(appendedItemsCount: newItems.count)
            hideInfiniteScrollLoading()
            return
        }
        items.append(contentsOf: newItems)
        if let animation = animation {
            let indexPaths = ((items.count - newItems.count)..<items.count).map({IndexPath(item: $0, section: index)})
            tableView.insertRows(at: indexPaths, with: animation)
        }else{
            tableView.reloadData()
        }
        sendTableViewSignal()
    }
    
    open func update(reload item: T, animation: UITableViewRowAnimation? = nil) {
        guard let index = self.index else { return }
        guard let tableView = self.tableView else { return }
        processNextUpdate()
        if let itemIndex = self.index(of: item) {
            if let animation = animation {
                let indexPath = IndexPath(item: itemIndex, section: index)
                tableView.reloadRows(at: [indexPath], with: animation)
            }else{
                tableView.reloadData()
            }
        }
    }
    
    open func update(delete item: T, animation: UITableViewRowAnimation? = nil) {
        guard let index = self.index else { return }
        guard let tableView = self.tableView else { return }
        processNextUpdate()
        if let itemIndex = self.index(of: item) {
            items.remove(at: itemIndex)
            if let animation = animation {
                let indexPath = IndexPath(item: itemIndex, section: index)
                tableView.deleteRows(at: [indexPath], with: animation)
            }else{
                tableView.reloadData()
            }
        }
        sendEmptyDatasourceSignal(appendedItemsCount: 0)
    }
    
    open func clear() {
        guard let tableView = self.tableView else { return }
        processNextUpdate()
        hideInfiniteScrollLoading()
        items.removeAll()
        tableView.reloadData()
    }
    
    open func update(failed error: Error) {
        sendErrorSignal(error: error)
    }
    
    open func processNextUpdate() {
        isFetchInProgress = false
        endRefreshControlAnimation()
    }
    
    open func index(of model: T) -> Int? {
        return items.index(of: model)
    }
    
    public func attachedToTableView(_ tableView: UITableView, ddTableViewController: DDTableViewController?, index: Int) {
        self.index = index
        self.ddTableViewContoller = ddTableViewController
        self.tableView = tableView
        candidateForNewFetchRequest()
        if isRefreshControlEnabled {
            if #available(iOS 10.0, *) {
                refreshControl = UIRefreshControl()
                refreshControl?.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
                tableView.refreshControl = refreshControl
            }
        }
        registerCells()
        sendLoadingSignal()
    }
    
    func candidateForNewFetchRequest() {
        if isFetchInProgress { return }
        showInfiniteScrollLoading()
        isFetchInProgress = true
        requestForMoreItems()
    }
    
    open func sendErrorSignal(error: Error) {
        if items.count == 0 {
            ddTableViewContoller?.showError()
        }else{
            processNextUpdate()
            hideInfiniteScrollLoading()
            self.lastError = error
        }
    }
    
    open func sendEmptyDatasourceSignal(appendedItemsCount: Int) {
        if appendedItemsCount == 0 && self.items.count == 0 {
            ddTableViewContoller?.showEmptyView()
        }
    }
    
    open func sendLoadingSignal() {
        if self.items.count == 0 {
            ddTableViewContoller?.showLoading()
        }
    }
    
    open func sendTableViewSignal() {
        if items.count > 0 {
            ddTableViewContoller?.showTableView()
        }
    }
    
    open func hideInfiniteScrollLoading() {
        if tableView.tableFooterView != nil {
            tableView?.tableFooterView = nil
        }
    }
    
    open func showInfiniteScrollLoading() {
        if !isInfiniteScrollEnabled { return }
        if items.count == 0 { return }
        if tableView.contentSize.height < UIScreen.main.bounds.height { return }
        let footer = infiniteScrollView()
        tableView?.tableFooterView = footer
    }
    
    open func endRefreshControlAnimation() {
        if refreshControl?.isRefreshing == true {
            refreshControl?.endRefreshing()
        }
    }
    
    
    
    /// MARK: - Register cells
    
    open func registerCells() {
        fatalError()
    }
    
    open func requestForMoreItems() {
        fatalError()
    }
    
    /// MARK: - refresh
    
    @objc open func didRefresh() {
        fatalError()
    }
    
    /// MARK: - Infinite scroll
    
    open func infiniteScrollView() -> UIView {
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



