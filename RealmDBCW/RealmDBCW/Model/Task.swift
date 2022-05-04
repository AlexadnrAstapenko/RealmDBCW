//
//  Task.swift
//  RealmDBCW
//
//  Created by Александр Астапенко on 3.05.22.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplit = false
}
