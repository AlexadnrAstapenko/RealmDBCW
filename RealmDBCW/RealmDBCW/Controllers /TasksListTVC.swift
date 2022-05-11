//
//  TasksListTVC.swift
//  RealmDBCW
//
//  Created by Александр Астапенко on 3.05.22.
//

import UIKit
import RealmSwift

class TasksListTVC: UITableViewController {
    
    // Result - отображает данные в реальном времени
    var tasksLists: Results<TaskList>!
    var notificationToken: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Claer DB
        //StorageManager.deleteAll()
        
        // выборка из БД + сортировка
        tasksLists = realm.objects(TaskList.self)
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonAdd))
        self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
    }

    
    @objc private func buttonAdd(_ sender: UIBarButtonItem) {
        allertForAddAndUpdatingTasksList(nil) {
        }
    }
    
    @IBAction func sortingSegmentioControll(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let taskList = tasksLists[indexPath.row]
        cell.configure(with: taskList)

        return cell
    }
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = tasksLists[indexPath.row]
        
        let deletContextItem = UIContextualAction(style: .destructive, title: "Delete") {_, _, _ in
            StorageManager.deleteTaskList(taskList: currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        
        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") {_, _, _ in
            self.allertForAddAndUpdatingTasksList(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        let doneContextItem = UIContextualAction(style: .destructive, title: "done") {_, _, _ in
            StorageManager.makeAllDone(taskList: currentList)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        
        deletContextItem.backgroundColor = .red
        editContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = .green
        let swipeAction = UISwipeActionsConfiguration(actions: [editContextItem, deletContextItem,doneContextItem])
        return swipeAction
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? TaskTVC,
        let indexPath = tableView.indexPathForSelectedRow else { return }
        dvc.currentTasksList = tasksLists[indexPath.row]
    }
    
    private func allertForAddAndUpdatingTasksList(_ tasklist: TaskList? = nil,
                                                  completion: @escaping () -> Void ) {
        let title = tasklist == nil ? "New list" : "Edit list"
        let messege = "Plese insert new list name"
        let buttonTitle = tasklist == nil ? "Save" : "Update"

        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)

        var alertTextField: UITextField!

        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            guard let newListName = alertTextField.text, !newListName.isEmpty else { return }

            if let tasklist = tasklist {
                StorageManager.editTaskList(taskList: tasklist ,
                                            newTaskistName: newListName)
            } else {
                let taskList = TaskList()
                taskList.name = newListName

                StorageManager.saveTaskList(taskList: taskList)
                completion()
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            alertTextField = textField
            if let listName = tasklist {
                alertTextField.text = listName.name
            }
            textField.placeholder = "List name"
        }

        present(alert, animated: true)
    }
    private func addTaskListObserver() {
        notificationToken = tasksLists.observe { change in
            switch change {
            case .initial:
                print("init")
            case let .update(_, deletions, isertions, modification):
                if !modification.isEmpty {
                    var indexPathArray = [IndexPath]()
                    for row in modification {
                        indexPathArray.append(IndexPath(row: row, section: 0))
                    }
                    self.tableView.reloadRows(at: indexPathArray, with: .automatic)
                }
                
            case let .error(error):
                print("error on observer \(error)")
            }
        }
    }
}
