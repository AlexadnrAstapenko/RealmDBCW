//
//  TaskTVC.swift
//  RealmDBCW
//
//  Created by Александр Астапенко on 3.05.22.
//

import UIKit
import RealmSwift

class TaskTVC: UITableViewController {

    var currentTasksList: TaskList!
    private var inComplete: Results<Task>!
    private var completedTask: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList.name
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        section == 0 ? inComplete.count : completedTask.count
        0 
    }

    @IBAction func addTask(_ sender: Any) {
        let title = "New list"
        let message = "Please insert list name"
        let buttonTitle = "Save"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            guard let textFieldame = alert.textFields?.first,
                  let name = textFieldame.text,
                  let textFieldNote = alert.textFields?.last,
                  let note = textFieldNote.text else { return }
            
            let task = Task()
            task.name = name
            task.note = note
            
            StorageManager.saveTask(taskList: self.currentTasksList, task: task)
            
            self.tableView.reloadData() 
            
//            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1 , section: 0)], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            textField.placeholder = "Task name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Task note "
        }
        present(alert, animated: true)
    }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}