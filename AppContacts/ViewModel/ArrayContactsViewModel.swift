//
//  ArrayContactsViewModel.swift
//  AppContacts
//
//  Created by Pavel Strukov on 1.05.22.
//

import UIKit

class ArrayContactsViewModel: ContactListViewModelType {
    func bindOnActivityVisible(with block: @escaping (Bool) -> Void) {
        block(false)
    }

    private lazy var modelContactsNotifier: ValueChangeNotifier<[UserContact]> = .init(value: testArray)

    private var testArray: [UserContact] = [
        .init(name: "Петя", phoneNumber: "1"),
        .init(name: "Вася", phoneNumber: "2"),
        .init(name: "Коля", phoneNumber: "3"),
        .init(name: "Дима", phoneNumber: "4"),
        .init(name: "Паша", phoneNumber: "5"),
        .init(name: "Саша", phoneNumber: "6")
    ] {
        didSet {
            modelContactsNotifier.value = testArray
        }
    }

    var contactsCount: Int {
        return testArray.count
    }

    var numberOfSections: Int {
        return 1
    }

    func getContact(at index: Int) -> UserContact? {
        return testArray[safe: index]
    }

    func deleteUserContact(at index: Int) {
        testArray.remove(at: index)
    }

    func saveUserContact(contact: UserContact) {
        testArray.append(contact)
    }

    func updateContact(index: Int, contact: UserContact) {
        testArray[index] = contact
    }

    func userDetails(for index: Int) -> MainTableViewCell.Model {
        let details = MainTableViewCell.Model(
            name: testArray[index].name,
            photo: testArray[index].imagePhoto,
            phoneString: testArray[index].phoneNumber
        )
        return details
    }

    func bindOnContactsUpdates(with block: @escaping ([UserContact]) -> Void) {
        modelContactsNotifier.bindObserver(with: block)
    }

    func viewDidLoad() {
    }
}
