//
//  PickerTableViewCell.swift
//  Craftycle
//
//  Created by Thinh Vo on 05/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

protocol PickerTableViewCellDelegate: NSObjectProtocol {
    func pickerTableViewCell(_ pickerTableViewCell: PickerTableViewCell, didSelectRowAtIndex index: Int)
}

class PickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var picker: UIPickerView!
    
    /// Delegate
    weak var delegate: PickerTableViewCellDelegate?
    
    var data: [Category]? {
        didSet {
            picker.reloadAllComponents()
        }
    }
    
    var selectedIndex: Int? {
        guard data != nil else { return nil}
        
        return picker.selectedRow(inComponent: 0)
    }
    
    // MARK: - Life cycle methods
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUp()
    }
    
    // MARK: - Helper methods
    fileprivate func setUp() {
        picker.dataSource = self
        picker.delegate = self
        
        selectionStyle = .none
    }
}

extension PickerTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.pickerTableViewCell(self, didSelectRowAtIndex: row)
    }
}

extension PickerTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let collection = data {
            return collection.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data?[row].name ?? ""
    }
    
    
}
