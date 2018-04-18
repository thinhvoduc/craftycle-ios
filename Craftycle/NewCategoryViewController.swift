//
//  NewCategoryViewController.swift
//  Lab6
//
//  Created by Thinh Vo on 04/04/2018.
//  Copyright © 2018 Thinh. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var category: Category?
    var image: UIImage? {
        return imageView.image
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New category"
        textField.delegate = self
        updateDoneButton()
        setupImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Private methods
    fileprivate func updateDoneButton() {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        doneButton.isEnabled = !text.isEmpty
    }
    
    fileprivate func setupImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_ :)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Actions
    @objc func imageViewTapped(_ sender: Any) {
        textField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateDoneButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateDoneButton()
        navigationItem.title = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === doneButton else {
            return
        }
        
        guard let text = textField.text, text.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            return
        }
        
        category = Category(id: Int.max, name: text, imageUrl: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate methods
extension NewCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
