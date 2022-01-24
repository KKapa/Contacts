//
//  ScondTableViewController.swift
//  AppContacts
//
//  Created by Павел Струков on 17.01.22.
//

import UIKit


class AddContactTableViewController: UITableViewController {
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func saveContact(_ sender: Any) {
        performSegue(withIdentifier: "savecontact", sender: nil)
    }
    
    @IBAction func cancelEnterContact(_ sender: Any) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
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
        } else {
            view.endEditing(true)
        }
    }
}

extension AddContactTableViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicked.image = info[.editedImage] as? UIImage
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.clipsToBounds = true
        dismiss(animated: true)
        
    }
}

extension AddContactTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
