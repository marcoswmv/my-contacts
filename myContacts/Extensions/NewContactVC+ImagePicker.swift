//
//  NewContactVC+ImagePicker.swift
//  myContacts
//
//  Created by Marcos Vicente on 02.10.2020.
//  Copyright © 2020 Antares Software Group. All rights reserved.
//

import UIKit

extension NewContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func choosePhotoSourceAlertController() {
        let photoLibraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showImagePickerController(sourceType: .camera)
            } else {
                Alert.showUnavailableCameraAlert(on: self)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        Alert.showPhotoSourceActionSheet(on: self,
                                         actions: [photoLibraryAction, cameraAction, cancelAction])
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
         let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
//            TO-DO: Somehow save the image as a JPG or PNG, to upload it to the server
            let image = originalImage.withRenderingMode(.alwaysOriginal)
            photo.image = image
        } else if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            let image = editedImage.withRenderingMode(.alwaysOriginal)
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
