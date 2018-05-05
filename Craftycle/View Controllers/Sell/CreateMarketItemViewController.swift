//
//  CreateMarketItemViewController.swift
//  Craftycle
//
//  Created by Thinh Vo Duc on 04/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class CreateMarketItemViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    var marketItem: MarketItem?
    var sellItem: Sell?
    private var categories: [Category] = []
    
    private var categoryService = CategoryService(ServiceConfiguration.defaultAppConfiguration()!)
    
    // MARK: - Life cyle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        
        loadCategories()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Actions
    @objc func imageViewTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    fileprivate func setupImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_ :)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    fileprivate func loadCategories() {
        // Show loading indicator
        LoadingManager.sharedManager.showLoading(message: "Loading...")
        
        // Add a bit delay here
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {[weak self] in
            self?.categoryService.getAllCategories(successBlock: { (categories) in
                LoadingManager.sharedManager.dismiss(animated: false)
                self?.categories = categories
                self?.categoryPickerView.reloadAllComponents()
            }, failureBlock: { _ in
                // Display loading indicator error
                LoadingManager.sharedManager.showError(message: "Failed to load category", dismissAfter: DispatchTimeInterval.seconds(1))
            })
        }
    }
    
    fileprivate func updateUploadButton() {
//        let _ = emailTextField.text
        guard let _ = imageView.image, categories.count > 0 else {
            uploadButton.isEnabled = true
            return
        }
        
        uploadButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "CreatingItemForSell" {
            sellItem = Sell(sellOrCraft: "something", photo: imageView.image, place: "Helsinki", price: "3€")
        }
        
    }
}

// MARK: - UIPickerViewDataSource methods
extension CreateMarketItemViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
}

extension CreateMarketItemViewController: UIPickerViewDelegate {
    
}

// MARK: - UIImagePickerControllerDelegate methods
extension CreateMarketItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        
        updateUploadButton()
    }
}
