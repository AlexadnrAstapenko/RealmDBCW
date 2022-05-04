//
//  TaskList.swift
//  RealmDBCW
//
//  Created by Александр Астапенко on 3.05.22.
//

import Foundation
import RealmSwift


class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let task = List<Task>()
}
