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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.clipsToBounds = true

        nameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }

    @IBAction func saveContact(_ sender: Any) {
        performSegue(withIdentifier: "savecontact", sender: nil)
    }
    
    @IBAction func cancelEnterContact(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)

        let isSelectPickerField = indexPath.row == 0
        if isSelectPickerField {
            askPickerSource { [weak self] selectedSource in
                selectedSource.flatMap { self?.chooseImagePicker(source: $0) }
            }
            return
        }
    }

    private func askPickerSource(callback: @escaping (UIImagePickerController.SourceType?) -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            callback(.photoLibrary)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            callback(.camera)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            callback(nil)
        }

        alertController.addActions([camera, photo, cancel])
        present(alertController, animated: true)
    }

    private func notifySourceNotSupported() {
        let alertController = UIAlertController(
            title: "Oops",
            message: "Selected source is not supported",
            preferredStyle: .alert
        )
        alertController.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension UIAlertController {
    func addActions(_ actions: [UIAlertAction]) {
        actions.forEach { addAction($0) }
    }
}

extension AddContactTableViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            notifySourceNotSupported()
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source

        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicked.image = info[.editedImage] as? UIImage
        picker.dismiss(animated: true)
    }
}

extension AddContactTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc private func textFieldChanged() {
        let hasText = nameTF.text?.isEmpty == false
        saveButton.isEnabled = hasText
    }
}
