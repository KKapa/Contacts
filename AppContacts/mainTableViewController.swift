//
//  mainTableViewController.swift
//  AppContacts
//
//  Created by Павел Струков on 17.01.22.
//

import UIKit
import CoreData

class MyContactsListTableViewController: UITableViewController {
    
    var contacts: [Contact] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        do {
            contacts = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func createContact(withTitle name: String, number: String, imagePhoto: Data) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context) else {return}
        let contactObject = Contact(entity: entity, insertInto: context)
        contactObject.name = name
        contactObject.phoneNumber = number
        contactObject.imagePhoto = imagePhoto
        
        do {
            try context.save()
            contacts.append(contactObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func goToMainFromEditVC(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
        guard segue.identifier == "savecontact", let svc = segue.source as? AddContactTableViewController else {return}
        let name = svc.nameTF.text
        let number = svc.numberTF.text
        let miniPhoto = svc.imagePicked.image
        let pngPhoto = miniPhoto?.pngData()
        
        createContact(withTitle: name!, number: number!, imagePhoto: pngPhoto!)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        //        if let objects = try? context.fetch(fetchRequest) {
        //            for task in objects {
        //                context.delete(task)
        //            }
        //        }
        //
        //        do {
        //            try context.save()
        //
        //        } catch let error as NSError {
        //            print(error.localizedDescription)
        //        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formain", for: indexPath) as! MainTableViewCell
        
        cell.nameLabel.text = contacts[indexPath.row].name
        cell.phoneLabel.text = contacts[indexPath.row].phoneNumber
        
        if let dataPhoto = contacts[indexPath.row].imagePhoto {
            let photo = UIImage(data: dataPhoto)
            cell.miniPhoto.image = photo
        }
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "edit" else {return}
        guard let evc = segue.destination as? EditVIewController  else {return}
        if let indexPath = tableView.indexPathForSelectedRow?.row {
            evc.nameTextField = contacts[indexPath].name
            evc.numberTextField = contacts[indexPath].phoneNumber
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "edit", sender: nil)
        
    }
}
