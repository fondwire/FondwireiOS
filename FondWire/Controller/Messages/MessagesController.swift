//
//  MessagesControllers.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/15/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit

private let messagesReuseId = "messagesCell"

class MessagesController: UITableViewController {
    
    //MARK: - Properties
    private lazy var headerView = MessageHeaderView()

    
    //MARK: - Lifecycle

    
    override func viewDidLoad() {
        super .viewDidLoad()
        configureUI()
     }

    //MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = .white
        navigationItem.title = "MESSAGES"
        tableView.register(MessageTableCell.self, forCellReuseIdentifier: messagesReuseId)
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: tableView.frame.width)
        tableView.tableHeaderView = headerView
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!

        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame

        tableView.tableHeaderView = headerView
    }
    
    
    //MARK: - Selectors
    
}

extension MessagesController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messagesReuseId, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        comingSoon()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 35))

        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.text = "  MESSAGES 1"
        label.font = .gothamBold(ofSize: 12)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        headerView.addSubview(label)
     
        return headerView
    }
}



