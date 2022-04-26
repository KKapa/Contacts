//
//  NetworkManager.swift
//  AppContacts
//
//  Created by Павел Струков on 20.03.22.
//

import Foundation
import UIKit

class NetworkManager {
    func fetchAppContacts(completionHandler: @escaping ([UserContact]) -> Void) {
        let urlString = "https://raw.githubusercontent.com/KKapa/KKapa-JSON-Contacts/main/JSON.json"
        let queue = DispatchQueue.global(qos: .background)
        
        queue.async {
            guard let url = URL(string: urlString) else { return }
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else { return }
                if let parsedDataContacts =  self.parseJSON(data: data) {
                    completionHandler(parsedDataContacts)
                }
            }.resume()
        }
    }
    
    func parseJSON(data: Data) -> [UserContact]? {
        let decoder = JSONDecoder()
        
        do {
            let contactsFromNetworkData = try decoder.decode([UserConactData].self, from: data)
            var contacts: [UserContact] = []
            for contact in contactsFromNetworkData {
                let name = contact.name
                let phone = contact.phoneNumber
                contacts.append(UserContact(name: name, phoneNumber: phone, imagePhoto: UIImage(imageLiteralResourceName: "defaultimage"), notes: nil, address: nil))
            }
            return contacts
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
