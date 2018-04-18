//
//  CategoryViewController.swift
//  Craftycle
//
//  Created by Thinh Vo on 18/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    
    /// Category source
    fileprivate var categories: [Category] = []
    
    fileprivate lazy var categoryService = CategoryService(ServiceConfiguration.defaultAppConfiguration()!)
    
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
}

// MARK: - UIPickerViewDelegate methods
extension CategoryViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = categories[row]
        title = category.name
        
        if let imageUrl = category.imageUrl {
            imageView.download(imageUrl)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
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
