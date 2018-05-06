//
//  MachineLearningResultViewController.swift
//  Craftycle
//
//  Created by Thinh Vo on 04/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class MachineLearningResultViewController: UIViewController {
    
    
    @IBOutlet weak var showRecyclingPointButton: UIButton!
    
    private struct Dimensions {
        static let cornerRadius: CGFloat = 8.0
    }
    
    // MARK: Life cycle methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.layer.cornerRadius = Dimensions.cornerRadius
        view.layer.masksToBounds = true
        
        showRecyclingPointButton.layer.cornerRadius = Dimensions.cornerRadius
        showRecyclingPointButton.layer.masksToBounds = true
    }
    
    // MARK: Helper methods
    fileprivate func setup() {
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
}

// MARK: - UIViewControllerTransitioningDelegate methods
extension MachineLearningResultViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropDownTransitionAnimator()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropDownTransitionAnimator()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BackgroundPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
