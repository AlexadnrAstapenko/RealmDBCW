//
//  TaskTVC.swift
//  RealmDBCW
//
//  Created by Александр Астапенко on 3.05.22.
//

import UIKit
import RealmSwift

class TaskTVC: UITableViewController, UIGestureRecognizerDelegate {
    
    var currentTasksList: TaskList!
    
    private var inComlete: Results<Task>!
    private var comletedTasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList.name
        setupLongPressGesture()
        filteredTask()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
    }
    
    @objc private func add() {
        allertForAddAndEditing()
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? inComlete[indexPath.row] : comletedTasks[indexPath.row]
        
        let buttonName = indexPath.section == 0 ? "Done" : "Undone"
        
        let deletContextItem = UIContextualAction(style: .destructive, title: "Delete") {_, _, _ in
            StorageManager.deleteTask(task: task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        
        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") {_, _, _ in
            self.allertForAddAndEditing(task)
        }
        
        let doneContextItem = UIContextualAction(style: .destructive, title: buttonName) {_, _, _ in
            StorageManager.makeDone(task: task)
            self.filteredTask()
            }
        
        deletContextItem.backgroundColor = .red
        editContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = indexPath.section == 0 ? .green : .darkGray
        
        let swipeAction = UISwipeActionsConfiguration(actions: [editContextItem, deletContextItem,doneContextItem])
        return swipeAction
    }
    
    @IBAction func allertForAddAndEditing(_ task: Task? = nil) {
        
        let title = "New task"
        let messege = task == nil ? "Plese insert new task name" : "Plese edit new task name"
        let buttonTitle = task == nil ? "Save" : "Update"
        
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        var nameTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            guard let newTaskName = nameTextField.text, !newTaskName.isEmpty,
                  let noteTask = noteTextField.text, !noteTask.isEmpty else { return }
            
            
            if let task = task {
                StorageManager.editTask(task: task, newNameTask: newTaskName, noteTask: noteTask)
                self.filteredTask()
            } else {
                let task = Task()
                task.name = newTaskName
                task.note = noteTask

                StorageManager.saveNewTask(taskList: self.currentTasksList, task: task)
                self.filteredTask()
//                self.tableView.insertRows(at: [IndexPath(row: self.inComlete.count - 1, section: 0)], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            nameTextField = textField
            textField.placeholder = "Task name"
            if let task = task {
                nameTextField.text = task.name
            }
        }
        alert.addTextField { textField in
            noteTextField = textField
            textField.placeholder = "Task note"
            if let task = task {
                noteTextField.text = task.note
            }
        }
        
        present(alert, animated: true)
    }
    
    private func filteredTask() {
        inComlete = currentTasksList.task.filter("isComplit = false")
        comletedTasks = currentTasksList.task.filter("isComplit = true")
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? inComlete.count : comletedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "In progress tasks" : "Comleted tasks"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = indexPath.section == 0 ? inComlete[indexPath.row] : comletedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if tableView.indexPathForRow(at: touchPoint) != nil {
            }
        }
    }
}
