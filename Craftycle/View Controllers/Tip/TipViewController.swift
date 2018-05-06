//
//  TipViewController.swift
//  Craftycle
//
//  Created by Thinh Vo on 06/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var showLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var categories: [Category] = []
    private lazy var categoryService = CategoryService(ServiceConfiguration.defaultAppConfiguration()!)
    private var selectedCategory: Category? {
        guard categories.count > 0 else {
            return nil
        }
        
        return categories[pickerView.selectedRow(inComponent: 0)]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        setUp()
        
        // Show loading
        showLoading(true)
        
        // UpdateUI
        tipLabel.text = ""
        updateUI()
        
        // Start to load cateogries
        categoryService.getAllCategories(successBlock: {[weak self] (categories) in
            self?.categories = categories
            self?.showLoading(false)
            self?.pickerView.reloadAllComponents()
            self?.updateUI()
        }) {[weak self] (_) in
            self?.showLoading(false)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func showLocationButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Helper methods
    fileprivate func showLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        activityIndicator.isHidden = !loading
        pickerView.isHidden = loading
    }
    
    fileprivate func setUp() {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        showLocationButton.layer.cornerRadius = 6.0
        showLocationButton.layer.masksToBounds = true
    }
    
    fileprivate func updateUI() {
        // Update location button
        showLocationButton.isEnabled = selectedCategory != nil
        
        // Update tip label
        if let category = selectedCategory {
            tipLabel.text = TipManager.tips(for: category)
        }
    }
}

extension TipViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
}

extension TipViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateUI()
    }
}
