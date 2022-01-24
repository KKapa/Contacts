//
//  mainTableViewController.swift
//  AppContacts
//
//  Created by Павел Струков on 17.01.22.
//

import UIKit
import CoreData

class MyContactsListTableViewController: UITableViewController {
    
    var Contacts: [Contact] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
              let context = appDelegate.persistentContainer.viewContext
              
              let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
              
              do {
                  Contacts = try context.fetch(fetchRequest)
              } catch let error as NSError {
                  print(error.localizedDescription)
              }

    }
    
   
    
    func createContact(withTitle name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context) else {return}
        let contactObject = Contact(entity: entity, insertInto: context)
        
        do {
            try context.save()
            Contacts.append(contactObject)
            contactObject.name = name
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
        guard segue.identifier == "savecontact", let svc = segue.source as? AddContactTableViewController else {return}
        var name = svc.nameTF.text
        createContact(withTitle: name!)
        self.tableView.reloadData()
        print("666")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Contacts.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formain", for: indexPath) as! MainTableViewCell

        cell.nameLabel.text = Contacts[indexPath.row].name

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
