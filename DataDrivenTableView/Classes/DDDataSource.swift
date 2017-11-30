//
//  DataDrivenDataSource.swift
//  DataDrivenTableView
//
//  Created by mohsen shakiba on 9/6/1396 AP.
//

import UIKit

public class DDDataSource {
    
    public var sections: [DDSectionProtocol] = []
    weak var tableView: UITableView?
    weak var ddTableViewController: DDTableViewController?
    
    public func add(section: DDSectionProtocol) {
        if section.index == -1 { return }
        insert(section: section, at: sections.count)
    }
    
    public func insert(section: DDSectionProtocol, at: Int) {
        guard let tableView = self.tableView else { return }
        if section.index == -1 { return }
        sections.insert(section, at: at)
        let indexSet = IndexSet(integer: at)
        tableView.insertSections(indexSet, with: .automatic)
        section.attachedToTableView(tableView, ddTableViewController: ddTableViewController, index: at)
    }
    
    public func remove(section: DDSectionProtocol) {
        guard let index = section.index else {
            return
        }
        if index == -1 { return }
        sections.remove(at: index)
        section.index = -1
        let indexSet = IndexSet(integer: index)
        tableView?.deleteSections(indexSet, with: .automatic)
    }
    
    public func move(section: DDSectionProtocol, index: Int) {
        guard let oldIndex = section.index else {
            return
        }
        if oldIndex == -1 { return }
        if oldIndex == index { return }
        sections.remove(at: oldIndex)
        sections.insert(section, at: index)
        tableView?.moveSection(oldIndex, toSection: index)
    }
    
    public func reload(section: DDSectionProtocol) {
        guard let index = section.index else {
            return
        }
        if index == -1 { return }
        let indexSet = IndexSet(integer: index)
        tableView?.reloadSections(indexSet, with: .automatic)
    }
    
    func numberOfSection() -> Int {
        return sections.count
    }
    
    func section(for index: Int) -> DDSectionProtocol {
        return sections[index]
    }
    
}
