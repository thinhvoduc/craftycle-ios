//
//  ImageTableViewCell.swift
//  Craftycle
//
//  Created by Thinh Vo on 05/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

protocol ImageTableViewCellDelegate: NSObjectProtocol {
    func imageTabeViewCellDidTapImageView(_ tableViewCell: ImageTableViewCell)
}

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    
    /// Delegate
    weak var delegate: ImageTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup
        setUp()
    }
    
    fileprivate func setUp() {
        customImageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(customImageViewTapped(_ :)))
        customImageView.addGestureRecognizer(gestureRecognizer)
        
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @objc func customImageViewTapped(_ sender: Any) {
        delegate?.imageTabeViewCellDidTapImageView(self)
    }
}
