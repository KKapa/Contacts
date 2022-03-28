//
//  ContactsListViewModel.swift
//  AppContacts
//
//  Created by Павел Струков on 28.03.22.
//

import UIKit
import CoreData

protocol ContactListViewModelType {
    
    var contactsCount: Int { get }
    var numberOfSections: Int { get }
    
    func deleteUserContact(at index: Int)
    
    func saveUserContact(contact: UserContact)
    
    func userDetails(for index: Int) -> MainTableViewCell.Model
    
    func subscribeOnContactsUpdates(with block: @escaping ([UserContact]) -> Void)
    
    func viewDidLoad()
    
}

class ContactsListViewModel: ContactListViewModelType {
    func saveUserContact(contact: UserContact) {
        modelContactsNotifier.value.append(contact)
        saveToDataBase(contact: contact)
    }
    
    
    private var contacts: [Contact] = []
    
    func subscribeOnContactsUpdates(with block: @escaping ([UserContact]) -> Void) {
        modelContactsNotifier.bindObserver(with: block)
    }
    
    private let modelContactsNotifier: ValueChangeNotifier<[UserContact]> = .init(value: [])
    
    var contactsCount: Int {
        return modelContactsNotifier.value.count
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    func userDetails(for index: Int) -> MainTableViewCell.Model {
        let details = MainTableViewCell.Model(
            name: modelContactsNotifier.value[index].name,
            photo: modelContactsNotifier.value[index].imagePhoto,
            phoneString: modelContactsNotifier.value[index].phoneNumber
        )
        return details
    }
    
    func viewDidLoad() {
        fetchContactsFromDatabase()
    }
    
    func deleteUserContact(at index: Int) {
        
        modelContactsNotifier.value.remove(at: index)
        let context = getContext()
        context.delete(contacts[index])
        
        do {
            try context.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    private func fetchContactsFromDatabase() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        
        do {
             contacts = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        var userContacts: [UserContact] = []
        
        for contact in contacts {
            let name = contact.name
            let number = contact.phoneNumber
            let dataImage = contact.imagePhoto
            let image = UIImage(data: dataImage!)
            
            userContacts.append(UserContact(name: name!, phoneNumber: number, imagePhoto: image, notes: nil, address: nil))
        }
        modelContactsNotifier.value.append(contentsOf: userContacts)
    }
    
    private func getContext() -> NSManagedObjectContext  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return  appDelegate.persistentContainer.viewContext
    }
    
    private func saveToDataBase(contact: UserContact) {
        
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context) else { return }
        let contactObject = Contact(entity: entity, insertInto: context)
        contactObject.name = contact.name
        contactObject.phoneNumber = contact.phoneNumber
        contactObject.imagePhoto = contact.imagePhoto?.pngData()
        
        do {
            try context.save()
            contacts.append(contactObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
