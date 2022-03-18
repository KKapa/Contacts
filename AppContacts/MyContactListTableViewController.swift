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
    var modelContactsList = UserContact.contactsList {
        didSet {
            self.tableView.reloadData()
            print(modelContactsList.count)
        }
    }
    
    func createModelContact(name: String, number: String, imagePhoto: UIImage) {
        modelContactsList.append(UserContact(name: name, phoneNumber: number, imagePhoto: imagePhoto, notes: nil, address: nil))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    func createContact(withTitle name: String, number: String, imagePhoto: Data) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context) else { return }
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        //        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        //        fetchRequest.sortDescriptors = [sortDescritor]
        do {
            contacts = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        for contact in contacts {  //наверное это тоже нужно оборачивать в метод
            let name = contact.name
            let number = contact.phoneNumber
            let dataImage = contact.imagePhoto
            let image = UIImage(data: dataImage!)
            
            modelContactsList.append(UserContact(name: name!, phoneNumber: number, imagePhoto: image, notes: nil, address: nil))
        }
        
        //                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //                let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        //                if let objects = try? context.fetch(fetchRequest) {
        //                    for task in objects {
        //                        context.delete(task)
        //                    }
        //                }
        //
        //                do {
        //                    try context.save()
        //
        //                } catch let error as NSError {
        //                    print(error.localizedDescription)
        //                }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modelContactsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formain", for: indexPath) as! MainTableViewCell
        
        cell.nameLabel.text = modelContactsList[indexPath.row].name
        cell.phoneLabel.text = modelContactsList[indexPath.row].phoneNumber
        cell.miniPhoto.image = modelContactsList[indexPath.row].imagePhoto
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            modelContactsList.remove(at: indexPath.row)
            let context = getContext()
            context.delete(contacts[indexPath.row])
            
            do {
                try context.save()
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        self.tableView.reloadData()
    }
    
    
    func getContext() -> NSManagedObjectContext  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return  appDelegate.persistentContainer.viewContext
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "edit" else { return }
        guard let evc = segue.destination as? EditVIewController  else { return }
        if let indexPath = tableView.indexPathForSelectedRow?.row {
            evc.nameTextField = modelContactsList[indexPath].name
            evc.numberTextField = modelContactsList[indexPath].phoneNumber
            evc.image = modelContactsList[indexPath].imagePhoto
            evc.indexEditingRow = indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "edit", sender: nil)
        
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
        guard segue.identifier == "savecontact", let svc = segue.source as? AddContactTableViewController else { return }
        let name = svc.nameTF.text
        let number = svc.numberTF.text
        let miniPhoto = svc.imagePicked.image
        let pngPhoto = miniPhoto?.pngData()
        
        createModelContact(name: name!, number: number!, imagePhoto: miniPhoto!)
        createContact(withTitle: name!, number: number!, imagePhoto: pngPhoto!)
        self.tableView.reloadData()
    }
    
    @IBAction func goToMainFromEditVC(segue: UIStoryboardSegue) {
        guard segue.identifier == "editChanges", let mvc = segue.source as? EditVIewController else { return }
        
        modelContactsList[mvc.indexEditingRow!].name = mvc.nameTF.text!
        modelContactsList[mvc.indexEditingRow!].phoneNumber = mvc.numberTF.text
        modelContactsList[mvc.indexEditingRow!].imagePhoto = mvc.imagePicked.image
        
        contacts[mvc.indexEditingRow!].name = mvc.nameTF.text
        contacts[mvc.indexEditingRow!].phoneNumber = mvc.numberTF.text
        let imagePhoto = mvc.imagePicked.image
        let pngPhoto = imagePhoto?.pngData()
        contacts[mvc.indexEditingRow!].imagePhoto = pngPhoto
        let context = getContext()
        self.tableView.reloadData()
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func cancelAction(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func addContactTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToAddContactTableViewController", sender: nil)
    }
    
    
}
