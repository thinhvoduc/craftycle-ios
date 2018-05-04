//
//  CategoryViewController.swift
//  Craftycle
//
//  Created by Thinh Vo on 18/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit
import CoreML
import Vision

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var craftSwitch: UISwitch!
    @IBOutlet weak var classificationLabel: UILabel!
    
    
    //ML request
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: craftycle().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    func updateClassifications(for image: UIImage) {
        classificationLabel.text = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
                
            }
        }
    }
        
    
    
    
    /// Category source
    fileprivate var categories: [Category] = []
    
    private lazy var categoryService = CategoryService(ServiceConfiguration.defaultAppConfiguration()!)
    
    private lazy var itemsService = ItemService(ServiceConfiguration.defaultAppConfiguration()!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Load all categories here
        categoryService.getAllCategories(successBlock: {[weak self] allCategories in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.categories = allCategories
            strongSelf.pickerView.reloadAllComponents()
            
        }, failureBlock: nil)
        
        setupImageView()
    }
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? NewCategoryViewController, let category = sourceVC.category {
            guard let categoryImage = sourceVC.image else { return }
            categoryService.createCategory(categoryImage, name: category.name, successBlock: {[weak self] category in
                guard let strongSelf = self else { return }
                
                if let c = category {
                    strongSelf.categories.append(c)
                    strongSelf.pickerView.reloadAllComponents()
                }
                
            }, failureBlock: nil)
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        LoadingManager.sharedManager.showLoading(message: "Loading...")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
            
            LoadingManager.sharedManager.showError(message: "Failed To upload", dismissAfter: DispatchTimeInterval.seconds(3))
        }
    }
    
    // MARK: - Actions
    @objc func imageViewTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        
        guard let image = imageView.image else { return }
        LoadingManager.sharedManager.showLoading(message: "Uploading...")
        itemsService.createItem(image, categoryId: 4, isCrafted: craftSwitch.isOn, successBlock: {[weak self] item in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
                LoadingManager.sharedManager.showSuccess(message: "Successed", dismissAfter: DispatchTimeInterval.seconds(1))
                print(item?.category)
            }
            
            // Disable upload button
            self?.uploadBarButtonItem.isEnabled = false
            }) {[weak self] error in
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
                    LoadingManager.sharedManager.showError(message: "Failed To Upload", dismissAfter: DispatchTimeInterval.seconds(1))
                    print(error)
                }
                
                // Disable upload button
                self?.uploadBarButtonItem.isEnabled = false
            }
    
        }
    fileprivate func setupImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_ :)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - UIImagePickerControllerDelegate methods
extension CategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageView.image = selectedImage
        updateClassifications(for: selectedImage)
        
        imageView.image = selectedImage
        uploadBarButtonItem.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDelegate methods
extension CategoryViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let category = categories[row]
//        title = category.name
//
//        if let imageUrl = category.imageUrl {
//            imageView.download(imageUrl)
//        } else {
//            imageView.image = UIImage(named: "placeholder")
//        }
    }
}

// MARK: - UIPickerViewDataSource methods
extension CategoryViewController: UIPickerViewDataSource {
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
