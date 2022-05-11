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
            print("error deleteAll")
        }
    }
    
    static func saveTaskList(taskList: TaskList) {
        do {
            try realm.write {
                realm.add(taskList)
            }
        } catch {
            print("error deleteAll")
        }
    }
    
    static func makeAllDone(taskList: TaskList) {
        do {
            try realm.write {
                taskList.task.setValue(true, forKey: "isComplit")
            }
        } catch {
            print("error deleteAll")
        }
    }
    
    static func deleteTaskList(taskList: TaskList) {
        do {
            try realm.write {
                let tasks = taskList.task
                realm.delete(tasks)
                realm.delete(taskList)
            }
        } catch {
            print("error deleteAll")
        }
    }
    
    static func editTaskList(taskList: TaskList,
                              newTaskistName: String) {
        do {
            try realm.write {
                taskList.name = newTaskistName
            }
        } catch {
            print("error deleteAll")
        }
    }
    
    static func deleteTask(task: Task) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("error deleteAll")
        }
    }
    
    static func editTask(task: Task,
                         newNameTask : String,
                         noteTask : String) {
        do {
            try realm.write {
                task.name = newNameTask
                task.note = noteTask
            }
        } catch {
            print("error deleteAll")
        }
    }

    static func makeDone(task: Task) {
        do {
            try realm.write {
                task.isComplit.toggle()
            }
        } catch {
            print("error deleteAll")
        }
    }
    
    static func saveNewTask(taskList: TaskList, task: Task) {
        do {
            try realm.write {
                taskList.task.append(task)
            }
        } catch {
            print("error saveNewTask")
        }
    }
}

