//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Байсаев Зубайр on 11.08.2022.
//

import UIKit
import Cosmos

class NewPlaceTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var imageIsChanged = false
    var currentPlace: Place!
    var currentRating = 0.0
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cosmosView.didTouchCosmos = { rating in
            self.currentRating = rating
            print("\(rating)")
        }
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditinScreen()
    }

   //MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            

            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }

    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier != "showMap" { return }
        
        let mapVC = segue.destination as! MapViewController
        mapVC.place.name = placeName.text ?? " "
        mapVC.place.location = placeLocation.text
        mapVC.place.type = placeType.text
        mapVC.place.imageData = placeImage.image?.pngData()

        }
    
    func savePlace() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             rating: currentRating)
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
                StorageManager.saveObject(newPlace)
            }
        }
        
    
    private func setupEditinScreen() {
        if currentPlace != nil {
            
            setupNavigationBar()
            imageIsChanged = true 
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            if let topItem = navigationController?.navigationBar.topItem {
                topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            cosmosView.rating = currentPlace.rating
        }
    }
    
    private func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

//MARK: Text Field Delegate

extension NewPlaceTableViewController: UITextFieldDelegate {
    
    //Hiding the keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}


//MARK: Work with image

extension NewPlaceTableViewController: UIImagePickerControllerDelegate {
    
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
        
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}
