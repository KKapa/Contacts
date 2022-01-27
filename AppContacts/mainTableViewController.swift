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
              let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
              do {
                  Contacts = try context.fetch(fetchRequest)
              } catch let error as NSError {
                  print(error.localizedDescription)
              }
    }
    
    func createContact(withTitle name: String, number: String, imagePhoto: Data) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context) else {return}
        let contactObject = Contact(entity: entity, insertInto: context)
        
        do {
            try context.save()
            Contacts.append(contactObject)
            contactObject.name = name
            contactObject.phoneNumber = number
            contactObject.imagePhoto = imagePhoto
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
        guard segue.identifier == "savecontact", let svc = segue.source as? AddContactTableViewController else {return}
        let name = svc.nameTF.text
        let number = svc.numberTF.text
        let miniPhoto = svc.imagePicked.image
        let pngPhoto = miniPhoto?.pngData()
        
        createContact(withTitle: name!, number: number!, imagePhoto: pngPhoto!)
        self.tableView.reloadData()
        print("666")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
//        if let objects = try? context.fetch(fetchRequest) {
//            for task in objects {9
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
        return Contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formain", for: indexPath) as! MainTableViewCell

        cell.nameLabel.text = Contacts[indexPath.row].name
        cell.phoneLabel.text = Contacts[indexPath.row].phoneNumber
        let imageData = Contacts[indexPath.row].imagePhoto
        let photo = imageData.flatMap { UIImage(data: $0) }

        cell.miniPhoto.image = photo
        
//        cell.miniPhoto.contentMode = .scaleAspectFill
//        cell.miniPhoto.clipsToBounds = true
//
        
        return cell
    }
}
