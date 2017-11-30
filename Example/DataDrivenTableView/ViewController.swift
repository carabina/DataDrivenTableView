//
//  ViewController.swift
//  DataDrivenTableView
//
//  Created by mohsenShakiba on 11/27/2017.
//  Copyright (c) 2017 mohsenShakiba. All rights reserved.
//

import UIKit
import DataDrivenTableView

public class TestSection: DDSection<Int> {
    
    public override var isInfiniteScrollEnabled: Bool {
        return true
    }
    
    public override var isRefreshControlEnabled: Bool {
        return true
    }
    
    public override func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    public override func cellForRow(at index: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = String(items[index])
        return cell
    }
    
    public override func heightForRow(at index: Int) -> CGFloat {
        return 50
    }
    
    public override func infiniteScrollView() -> UIView {
        let label = UILabel(frame: .init(origin: .zero, size: CGSize(width: 100, height: 50)))
        label.text = "LOADING"
        return label
    }
    
    public override func didRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.clear()
            self.update(append: [0])
        }
    }
    
    public override func requestForMoreItems() {
        if items.count > 20 {
            self.update(append: [])
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.update(append: [1,2,3,4,5])
        }
    }
    
}

class ViewController: DDTableViewController {

    let section = TestSection(items: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ddTableView.dataSource.add(section: section)
    }
    
    override func showLoading() {
        let view = UIView()
        view.backgroundColor = UIColor.red
        self.animate(to: view)
    }
}

