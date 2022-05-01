//
//  ContactsListViewModel.swift
//  AppContacts
//
//  Created by Павел Струков on 28.03.22.
//

import UIKit
import CoreData
import MapKit

protocol ContactListViewModelType {
    var contactsCount: Int { get }
    var numberOfSections: Int { get }

    func getContact(at index: Int) -> UserContact?

    func deleteUserContact(at index: Int)
    func saveUserContact(contact: UserContact)
    func updateContact(index: Int, contact: UserContact)
    
    func userDetails(for index: Int) -> MainTableViewCell.Model
    func bindOnContactsUpdates(with block: @escaping ([UserContact]) -> Void)
    func bindOnActivityVisible(with block: @escaping (Bool) -> Void)

    func viewDidLoad()
}

class DataBaseContactsViewModel: ContactListViewModelType {
    private var contacts: [Contact] = []

    private let networkManager: NetworkManager?
    private let modelContactsNotifier: ValueChangeNotifier<[UserContact]> = .init(value: [])
    private let activityNotifier: ValueChangeNotifier<Bool> = .init(value: false)

    var contactsCount: Int {
        return modelContactsNotifier.value.count
    }

    var numberOfSections: Int {
        return 1
    }

    init(networkManager: NetworkManager?) {
        self.networkManager = networkManager
    }

    func getContact(at index: Int) -> UserContact? {
        return modelContactsNotifier.value[safe: index]
    }

    func deleteUserContact(at index: Int) {
        let contact = modelContactsNotifier.value.remove(at: index)

        let context = getContext()
        let contactToDelete = contacts.remove(at: index)
        context.delete(contactToDelete)

        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }

    func saveUserContact(contact: UserContact) {
        modelContactsNotifier.value.append(contact)
        saveToDataBase(contact: contact)
    }

    func updateContact(index: Int, contact: UserContact) {
        modelContactsNotifier.value[index] = contact

        let context = getContext()
        let updatedContact = contacts[index]

        updatedContact.name = contact.name
        updatedContact.phoneNumber = contact.phoneNumber
        updatedContact.imagePhoto = contact.imagePhoto?.pngData()

        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func bindOnContactsUpdates(with block: @escaping ([UserContact]) -> Void) {
        modelContactsNotifier.bindObserver(with: block)
    }

    func bindOnActivityVisible(with block: @escaping (Bool) -> Void) {
        activityNotifier.bindObserver(with: block)
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
        fetchFromNetwork()
    }

    private func fetchFromNetwork() {
        guard let manager = networkManager else {
            return
        }
        activityNotifier.value = true

        manager.fetchAppContacts { [weak self] contacts in
            DispatchQueue.main.async {
                self?.activityNotifier.value = false
            }
            self?.modelContactsNotifier.value.append(contentsOf: contacts)
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
            let image = dataImage.flatMap { UIImage(data: $0) }

            let contact = UserContact(
                name: name!,
                phoneNumber: number,
                imagePhoto: image
            )
            
            userContacts.append(contact)
        }
        modelContactsNotifier.value.append(contentsOf: userContacts)
    }
    
    private func dataBaseUpdateAfterDeleteAction() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        
        do {
            contacts = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getContext() -> NSManagedObjectContext  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveToDataBase(contact: UserContact) {
        let context = getContext()

        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context) else {
            return
        }
        let contactObject = Contact(entity: entity, insertInto: context)
        contactObject.name = contact.name
        contactObject.phoneNumber = contact.phoneNumber
        contactObject.imagePhoto = contact.imagePhoto?.pngData()
        contacts.append(contactObject)
        
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
