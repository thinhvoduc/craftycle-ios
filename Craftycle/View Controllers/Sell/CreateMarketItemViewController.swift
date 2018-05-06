//
//  CreateMarketItemViewController.swift
//  Craftycle
//
//  Created by Thinh Vo Duc on 04/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit
import CoreLocation

class CreateMarketItemViewController: UIViewController {

    enum Section: Int {
        case imagePicker = 0
        case categoryPicker
        case detailInfo
    }
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var categoryPickerView: UIPickerView!
//    @IBOutlet weak var priceTextField: UITextField!
//    @IBOutlet weak var locationTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    private var categories: [Category] = []
    
    private var categoryService = CategoryService(ServiceConfiguration.defaultAppConfiguration()!)
    
    private var dataSource: BasicDataSource<Section>!
    
    // Data for creating market item
    private var pickedImage: UIImage?
    
    private var selectedCategory: Category? {
        guard categories.count > 0 else {
            return nil
        }
        
        return categories[selectedCategoryIndex]
    }
    
    private var selectedPlaceMark: CLPlacemark?
    
    private var email: String?
    
    private var price: Double?
    
    var marketItem: MarketItem?
    
    // TODO: Remove this Sell class
    var sellItem: Sell?
    
    private var selectedCategoryIndex: Int = 0
    
    // MARK: - Life cyle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadCategories()
        prepareDataSource()
        updateUploadButton()
    }
    
    // MARK: Helper methods
    fileprivate func setup() {
        // UITableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    fileprivate func prepareDataSource() {
        dataSource = BasicDataSource<Section>()
        
        // Add image picker section
        let row = BasicDataSourceRow(pickedImage ?? UIImage(named: "placeholder")!)
        let imagePickerSection = BasicDataSourceSection([row])
        dataSource.addSection(imagePickerSection, at: Section.imagePicker)
        
        // Category picker
        var pickerSection: BasicDataSourceSection
        if categories.count > 0 {
            let data = self.categories as Any
            let row = BasicDataSourceRow(data)
            pickerSection = BasicDataSourceSection([row])
        } else {
            pickerSection = BasicDataSourceSection([])
        }
        
        // Detail info
        let detailInfoRow = BasicDataSourceRow(nil)
        let detailInfoSection = BasicDataSourceSection([detailInfoRow])
        dataSource.addSection(detailInfoSection, at: .detailInfo)
        
        dataSource.addSection(pickerSection, at: Section.categoryPicker)
    }
    
    fileprivate func loadCategories() {
        // Show loading indicator
        LoadingManager.sharedManager.showLoading(message: "Loading...")
        
        // Add a bit delay here
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {[weak self] in
            self?.categoryService.getAllCategories(successBlock: { (categories) in
                LoadingManager.sharedManager.dismiss(animated: false)
                self?.categories = categories
                self?.prepareDataSource()
                self?.tableView.reloadData()
            }, failureBlock: { _ in
                // Display loading indicator error
                LoadingManager.sharedManager.showError(message: "Failed to load category", dismissAfter: DispatchTimeInterval.seconds(1))
            })
        }
    }
    
    fileprivate func updateUploadButton() {
        //        let _ = emailTextField.text
        guard let _ = pickedImage else {
            uploadButton.isEnabled = true
            return
        }
        
        uploadButton.isEnabled = true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "CreatingItemForSell" {
            sellItem = Sell(sellOrCraft: "", photo: pickedImage, place: selectedPlaceMark?.title ?? "", price: price, emailContact: email)
        }
        
    }
    
}
    /*
    // MARK: - Actions
    
    // MARK: - Private methods
    fileprivate func setupImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_ :)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
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


 
 */

// MARK: - UITableViewDataSource methods
extension CreateMarketItemViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.sectionAtIndex(section)?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let sectionData = dataSource.sectionAtIndex(indexPath.section)
        let cell: UITableViewCell
        
        switch section {
        case .imagePicker:
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            if let image = sectionData?.rowAt(0).data as? UIImage {
                imageCell.customImageView.image = image
            }
            imageCell.delegate = self
            
            cell  = imageCell
        case .categoryPicker:
            let pickerCell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
            if let categories = sectionData?.rowAt(0).data as? [Category] {
                pickerCell.data = categories
            }
            pickerCell.delegate = self
            
            cell = pickerCell
            
        case .detailInfo:
            let detailInfoCell = tableView.dequeueReusableCell(withIdentifier: "MarketItemInfoTableViewCell", for: indexPath) as! MarketItemInfoTableViewCell
            detailInfoCell.locationTextField.text = selectedPlaceMark?.title
            detailInfoCell.delegate = self
            cell = detailInfoCell
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate methods
extension CreateMarketItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            return 0
        }
        
        switch section {
        case .imagePicker:
            return 220
        case .categoryPicker:
            if let categorySection = dataSource.sectionAtIndex(section.rawValue) {
                return categorySection.numberOfRows > 0 ? 150 : 0
            }
            
            return 0
        case .detailInfo:
            return 240
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}

// MARK: - ImageTableViewCellDeletage methods
extension CreateMarketItemViewController: ImageTableViewCellDelegate {
    func imageTabeViewCellDidTapImageView(_ tableViewCell: ImageTableViewCell) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - PickerTableViewCellDelegate methods
extension CreateMarketItemViewController: PickerTableViewCellDelegate {
    func pickerTableViewCell(_ pickerTableViewCell: PickerTableViewCell, didSelectRowAtIndex index: Int) {
        selectedCategoryIndex = index
    }
}

// MARK: - MarketItemInfoTableViewCellDelegate methods
extension CreateMarketItemViewController: MarketItemInfoTableViewCellDelegate {
    func marketItemInfoTableViewCellDidSelectLocationTextField(_ tableViewCell: MarketItemInfoTableViewCell, didEndEditingPrice price: Double?) {
        self.price = price
    }
    
    func marketItemInfoTableViewCellDidSelectLocationTextField(_ tableViewCell: MarketItemInfoTableViewCell, didEndEditingEmail email: String?) {
        self.email = email
    }
    
    func marketItemInfoTableViewCellDidSelectLocationTextField(_ tableViewCell: MarketItemInfoTableViewCell) {
        let locationViewController = LocationPickerViewController()
        locationViewController.delegate = self
        
        navigationController?.pushViewController(locationViewController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate methods
extension CreateMarketItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        pickedImage = selectedImage
        dismiss(animated: true, completion: nil)
        
        // Reload
        prepareDataSource()
        tableView.reloadData()
    }
}

// MARK: - LocationPickerViewControllerDelegate methods
extension CreateMarketItemViewController: LocationPickerViewControllerDelegate {
    func locationPickerViewController(_ viewController: UIViewController, didSelectPlacemark placemark: CLPlacemark) {
        selectedPlaceMark = placemark
        // Reload location text field on the table view cell
        tableView.reloadData()
    }
}
