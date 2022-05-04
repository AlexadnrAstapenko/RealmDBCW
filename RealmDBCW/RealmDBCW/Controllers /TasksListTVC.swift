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
        alertForAddingList()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in _: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        tasksLists.count
    }

    // MARK: Private

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         let taskList = tasksLists[indexPath.row]
         cell.textLabel?.text = taskList.name
         cell.detailTextLabel?.text = String(taskList.task.count)
         return cell
     }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
     }
     */
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? TaskTVC,
        let indexPath = tableView.indexPathForSelectedRow else { return  }
         dvc.currentTasksList = tasksLists[indexPath.row]
     }

    private func alertForAddingList() {
        let title = "New list"
        let message = "Please insert list name"
        let buttonTitle = "Save"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let name = textField.text else { return }
            let task = TaskList()
            task.name = name
            
            StorageManager.saveTaskList(taskList: task)
            
            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1 , section: 0)], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            textField.placeholder = "List name"
        }
        present(alert, animated: true)
    }
}
