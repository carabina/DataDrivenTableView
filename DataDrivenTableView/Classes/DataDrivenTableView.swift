//
//  DataDrivenTableView.swift
//  DataDrivenTableView
//
//  Created by mohsen shakiba on 9/6/1396 AP.
//

import Foundation
import UIKit

public class DDTableView: UIView {
    
    public let dataSource = DDDataSource()
    public let tableViewStyle: UITableViewStyle
    public var tableView: UITableView!
    
    public init(style: UITableViewStyle) {
        self.tableViewStyle = style
        super.init(frame: .zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        tableViewStyle = .plain
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        tableView = UITableView(frame: .zero, style: tableViewStyle)
        dataSource.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
    }
    
    public override func layoutSubviews() {
        tableView.frame = self.bounds
        super.layoutSubviews()
    }
    
}

extension DDTableView: UITableViewDataSource {
    
    @nonobjc public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSection()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = dataSource.section(for: section)
        return section.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = dataSource.section(for: indexPath.section)
        return section.cellForRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = dataSource.section(for: section)
        return section.titleForFooter()
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = dataSource.section(for: section)
        return section.titleForHeader()
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = dataSource.section(for: indexPath.section)
        return section.canEditRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let section = dataSource.section(for: indexPath.section)
        return section.canMoveRow(at: indexPath.row)
    }
    
}

extension DDTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.section(for: indexPath.section)
        return section.heightForRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.section(for: indexPath.section)
        return section.heightForRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = dataSource.section(for: indexPath.section)
        return section.shouldHightlighRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataSource.section(for: indexPath.section)
        section.didSelectRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let section = dataSource.section(for: indexPath.section)
        section.didDeselectRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = dataSource.section(for: indexPath.section)
        section.willDisplayCell(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = dataSource.section(for: indexPath.section)
        section.didEndDisplayingCell(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let section = dataSource.section(for: indexPath.section)
        section.didHighlightRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let section = dataSource.section(for: indexPath.section)
        section.didUnhighlightRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = dataSource.section(for: section)
        return section.viewForFooter()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = dataSource.section(for: section)
        return section.viewForHeader()
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = dataSource.section(for: section)
        return section.heightForFooter() ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = dataSource.section(for: section)
        return section.heightForHeader() ?? 0
    }
    
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let section = dataSource.section(for: section)
        return section.heightForFooter() ?? 0
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let section = dataSource.section(for: section)
        return section.heightForHeader() ?? 0
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let section = dataSource.section(for: indexPath.section)
        return section.editingActionsForRow(at: indexPath.row)
    }
    
    
}
