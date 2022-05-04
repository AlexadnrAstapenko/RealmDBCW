//
//  StorageManager.swift
//  RealmDBCW
//
//  Created by Александр Астапенко on 3.05.22.
//

import Foundation
import RealmSwift

let realm = try! Realm()

// MARK: - StorageManager

class StorageManager {
    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error func deleteAll")
        }
    }
    
    static func saveTaskList(taskList: TaskList) {
        do {
            try realm.write {
                realm.add(taskList)
            }
        } catch {
            print("Error func saveTaskList")
        }
    }
    static func saveTask(taskList: TaskList, task: Task ) {
        do {
            try realm.write {
                taskList.task.append(task)
            }
        } catch {
            print("Error func saveTaskList")
        }
    }
}
