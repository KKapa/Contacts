//
//  NetworkManager.swift
//  AppContacts
//
//  Created by Павел Струков on 20.03.22.
//

import Foundation

class NetworkManager {
    
    func fetchAppContacts() {
        let urlString = "https://raw.githubusercontent.com/KKapa/KKapa-JSON-Contacts/main/JSON.json"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else { return }
            let parsedDataContacts =  self.parseJSON(data: data)
            
        }.resume()
        
    }
    
    func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        
        do {
            guard let contactsFromNetworkData = try? decoder.decode([UserConactData].self, from: data) else { return }
            contactsFromNetworkData.forEach{print($0)}
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
