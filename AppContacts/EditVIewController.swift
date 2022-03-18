//
//  EditVIewController.swift
//  AppContacts
//
//  Created by Павел Струков on 30.01.22.
//

import UIKit

class EditVIewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var changeImage: UIButton!
    
    var nameTextField: String?
    var numberTextField: String?
    var image: UIImage?
    var indexEditingRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.text = nameTextField
        numberTF.text = numberTextField
        self.imagePicked.image = image
        registerForKeyboardNotifications()
    }
    
    @IBAction func tapForChangeImage(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(camera)
        alertController.addAction(photo)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
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
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        self.view.frame.origin.y -= keyboardHeight
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
        
    }
    
    
}

extension EditVIewController: UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicked.image = info[.editedImage] as? UIImage
        imagePicked.contentMode = .scaleAspectFill
        imagePicked.clipsToBounds = true
        dismiss(animated: true)
    }
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
}
