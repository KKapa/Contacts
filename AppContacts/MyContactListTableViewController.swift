//
//  mainTableViewController.swift
//  AppContacts
//
//  Created by Павел Струков on 17.01.22.
//

import UIKit
import CoreData

class MyContactsListTableViewController: UITableViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var viewModel: ContactListViewModelType = DataBaseContactsViewModel(networkManager: NetworkManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        viewModel.bindOnContactsUpdates{ [weak self] contacts in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.bindOnActivityVisible { [unowned self] visible in
            visible
                ? activityIndicator.startAnimating()
                : activityIndicator.stopAnimating()
        }
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        viewModel.viewDidLoad()
    
//                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                                let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
//                                if let objects = try? context.fetch(fetchRequest) {
//                                    for task in objects {
//                                        context.delete(task)
//                                    }
//                                }
//
//                                do {
//                                    try context.save()
//
//                                } catch let error as NSError {
//                                    print(error.localizedDescription)
//                                }
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
    }
    
    func getContext() -> NSManagedObjectContext  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return  appDelegate.persistentContainer.viewContext
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "edit" else { return }
        guard let evc = segue.destination as? EditVIewController  else { return }

        if let index = tableView.indexPathForSelectedRow?.row, let selectedContact = viewModel.getContact(at: index) {
            evc.nameTextField = selectedContact.name
            evc.numberTextField = selectedContact.phoneNumber
            evc.image = selectedContact.imagePhoto
            evc.indexEditingRow = index
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
    }
    
    @IBAction func goToMainFromEditVC(segue: UIStoryboardSegue) {
        guard segue.identifier == "editChanges", let mvc = segue.source as? EditVIewController else {
            return
        }

        let updatedContact = UserContact(
            name: mvc.nameTF.text!,
            phoneNumber: mvc.numberTF.text,
            imagePhoto: mvc.imagePicked.image
        )

        viewModel.updateContact(index: mvc.indexEditingRow!, contact: updatedContact)
    }

    private func createModelContact(name: String, number: String, imagePhoto: UIImage?) {
        let contact = UserContact(name: name, phoneNumber: number, imagePhoto: imagePhoto)
        viewModel.saveUserContact(contact: contact)
    }

    @IBAction func cancelAction(segue: UIStoryboardSegue) {
    }
    
    @IBAction func addContactTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToAddContactTableViewController", sender: nil)
    }
}
