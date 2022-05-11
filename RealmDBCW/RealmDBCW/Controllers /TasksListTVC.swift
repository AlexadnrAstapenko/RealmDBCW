//
//  TasksListTVC.swift
//  RealmDBCW
//
//  Created by Александр Астапенко on 3.05.22.
//

import RealmSwift
import UIKit

// let realm = try! Realm()

class TasksListTVC: UITableViewController {
    // MARK: Internal

    var tasksLists: Results<TaskList>!

    override func viewDidLoad() {
        tasksLists = realm.objects(TaskList.self)
        super.viewDidLoad()
    }

    @IBAction func addButtonPress(_: UIBarButtonItem) {
        alertForAddingList(title: "New list",
                           message: "Please insert list name",
                           buttonTitle: "Save",
                           placeHolder: "List name")
    }

    // MARK: - Table view data source

//    override func numberOfSections(in _: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let taskList = tasksLists[indexPath.row]
        cell.textLabel?.text = taskList.name
        cell.detailTextLabel?.text = String(taskList.task.count)
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            let task = self.tasksLists[indexPath.row]
            StorageManager.deleteTask(taskList: task)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }

        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, completion in
            completion(true)
        }

        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, completion in
            completion(true)
        }
        editAction.backgroundColor = .systemOrange
        doneAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, doneAction])
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let dvc = segue.destination as? TaskTVC,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        dvc.currentTasksList = tasksLists[indexPath.row]
    }

    // MARK: Private

    private func alertForAddingList(title: String, message: String, buttonTitle: String, placeHolder: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let name = textField.text else { return }
            let task = TaskList()
            task.name = name
            StorageManager.saveTaskList(taskList: task)

            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            textField.placeholder = placeHolder
        }
        present(alert, animated: true)
    }
}
