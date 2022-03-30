//
//  mainTableViewController.swift
//  AppContacts
//
//  Created by Павел Струков on 17.01.22.
//

import UIKit
import CoreData

class MyContactsListTableViewController: UITableViewController {
    
    var viewModel: ContactListViewModelType = ContactsListViewModel()
    
    
    
    let networkManager = NetworkManager()
    
    func createModelContact(name: String, number: String, imagePhoto: UIImage) {
      let contact = UserContact(name: name, phoneNumber: number, imagePhoto: imagePhoto, notes: nil, address: nil)
        viewModel.saveUserContact(contact: contact)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
        viewModel.subscribeOnContactsUpdates { [weak self] contacts in
            self?.tableView.reloadData()
        }
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        networkManager.fetchAppContacts()
        
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
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formain", for: indexPath) as! MainTableViewCell
        
        let details = viewModel.userDetails(for: indexPath.row)
        cell.configure(with: details)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteUserContact(at: indexPath.row)
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
            
            let selectedContact = viewModel.returnCurrentContact(index: indexPath)
            evc.nameTextField = selectedContact.name
            evc.numberTextField = selectedContact.name
            evc.image = selectedContact.imagePhoto
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
       
        
        createModelContact(name: name!, number: number!, imagePhoto: miniPhoto!)
        self.tableView.reloadData()
    }
    
    @IBAction func goToMainFromEditVC(segue: UIStoryboardSegue) {
        guard segue.identifier == "editChanges", let mvc = segue.source as? EditVIewController else { return }
        
        let editContact = viewModel.returnCurrentContact(index: mvc.indexEditingRow!)
        
        viewModel.updateVMContact(index: mvc.indexEditingRow!, name: mvc.nameTF.text!, imagePhoto: mvc.imagePicked.image!, phoneNumber: mvc.numberTF.text!)
        
        viewModel.updateContactDataBase(index: mvc.indexEditingRow!, name: mvc.nameTF.text!, imagePhoto: mvc.imagePicked.image?.pngData(), phoneNumber: mvc.numberTF.text!)
        self.tableView.reloadData()
        
        
//        editContact.name = mvc.nameTF.text!
//        editContact.phoneNumber = mvc.numberTF.text
//        editContact.imagePhoto = mvc.imagePicked.image
        
//        contacts[mvc.indexEditingRow!].name = mvc.nameTF.text
//        contacts[mvc.indexEditingRow!].phoneNumber = mvc.numberTF.text
//        let imagePhoto = mvc.imagePicked.image
//        let pngPhoto = imagePhoto?.pngData()
//        contacts[mvc.indexEditingRow!].imagePhoto = pngPhoto
//        let context = getContext()
//        self.tableView.reloadData()
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
    }
    
    @IBAction func cancelAction(segue: UIStoryboardSegue) {
    }
    
    @IBAction func addContactTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToAddContactTableViewController", sender: nil)
    }
    
}
