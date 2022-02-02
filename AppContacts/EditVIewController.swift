//
//  EditVIewController.swift
//  AppContacts
//
//  Created by Павел Струков on 30.01.22.
//

import UIKit

class EditVIewController: UIViewController {
    
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    
    var nameTextField: String?
    var numberTextField: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.text = nameTextField
        numberTF.text = numberTextField
        registerForKeyboardNotifications()
    }
    
    @IBAction func goBackTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "fromEditTomain", sender: nil)
    }
    
    @IBAction func saveEdit(_ sender: Any) {
        let name = nameTF.text
        let number = numberTF.text
    
    }
    
    func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrolView.contentSize.height = scrolView.contentSize.height + keyboardHeight.height
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrolView.contentOffset = CGPoint.zero
    }
    
    
}

extension EditVIewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
