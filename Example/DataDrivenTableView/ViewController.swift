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
    
    public override func requestForMoreItems() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.update(result: .append([4,5,6]))
        }
    }
    
}

class ViewController: UIViewController {

    let ddTableView = DDTableView(style: .plain)
    let section = TestSection(items: [1,2,3])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(ddTableView)
        ddTableView.frame = self.view.bounds
        ddTableView.dataSource.add(section: section)
    }
}

