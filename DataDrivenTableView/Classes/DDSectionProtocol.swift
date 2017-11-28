//
//  DataDrivenSectionProtocol.swift
//  DataDrivenTableView
//
//  Created by mohsen shakiba on 9/6/1396 AP.
//

import Foundation

/**
 * base protocol for section
 */
public protocol DDSectionProtocol: class {
    
    /// MARK: - properties
    
    /// index of section in table view
    /// in case of nil mean the table hasn't beed added yet
    /// in case of -1 means the section is removed
    var index: Int? { get set}
    
    /// MARK: - methods
    
    /// this method is called once the section has been attached to table view
    func attachedToTableView(_ tableView: UITableView, index: Int)
    
    /// number of items in the section
    func numberOfRows() -> Int
    
    /// MARK: - Header and footer

    func titleForHeader() -> String?
    func titleForFooter() -> String?
    func viewForHeader() -> UIView?
    func viewForFooter() -> UIView?
    func heightForHeader() -> CGFloat?
    func heightForFooter() -> CGFloat?
    
    /// cell for row at index
    func cellForRow(at index: Int) -> UITableViewCell
    func heightForRow(at index: Int) -> CGFloat
    func didSelectRow(at index: Int) -> Bool
    func didDeselectRow(at index: Int)
    func shouldHightlighRow(at index: Int) -> Bool
    func didHighlightRow(at index: Int)
    func didUnhighlightRow(at index: Int)
    func willDisplayCell(at index: Int)
    func didEndDisplayingCell(at index: Int)
    func canEditRow(at index: Int) -> Bool
    func canMoveRow(at index: Int) -> Bool
    func editingActionsForRow(at index: Int) -> [UITableViewRowAction]?
    
}
