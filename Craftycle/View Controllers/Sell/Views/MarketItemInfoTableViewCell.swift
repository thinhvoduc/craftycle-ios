//
//  MarketItemInfoTableViewCell.swift
//  Craftycle
//
//  Created by Thinh Vo on 05/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

protocol MarketItemInfoTableViewCellDelegate: NSObjectProtocol {
    func marketItemInfoTableViewCellDidSelectLocationTextField(_ tableViewCell: MarketItemInfoTableViewCell)
    
    func marketItemInfoTableViewCellDidSelectLocationTextField(_ tableViewCell: MarketItemInfoTableViewCell, didEndEditingPrice price: Double?)
    
    func marketItemInfoTableViewCellDidSelectLocationTextField(_ tableViewCell: MarketItemInfoTableViewCell, didEndEditingEmail email: String?)
}

class MarketItemInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    weak var delegate: MarketItemInfoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        priceTextField.delegate = self
        locationTextField.delegate = self
        emailTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MarketItemInfoTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === locationTextField {
            delegate?.marketItemInfoTableViewCellDidSelectLocationTextField(self)
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === priceTextField {
            let price = Double(textField.text ?? "0.0")
            delegate?.marketItemInfoTableViewCellDidSelectLocationTextField(self, didEndEditingPrice: price)
        }
        
        if textField === emailTextField {
            let email = textField.text
            delegate?.marketItemInfoTableViewCellDidSelectLocationTextField(self, didEndEditingEmail: email)
        }
    }
}
