//
//  UiTableViewCell.swift
//  RealmDBCW
//
//  Created by Александр Астапенко on 11.05.22.
//

import UIKit

extension UITableViewCell {
    func configure(with tasksList:TaskList ) {
        
        let currentTasks = tasksList.task.filter("isComplit = false")
        let completedTasks = tasksList.task.filter("isComplit = true")
        textLabel?.text = tasksList.name
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = String(currentTasks.count)
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .green
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .green
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .green
        }
    }
}
