//
//  LoadingManager.swift
//  Craftycle
//
//  Created by Thinh Vo on 27/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import Foundation
import DTCircularActivityIndicator

final class LoadingManager: NSObject {
    
    private struct Dimemsion {
        static let verticalSpacing: CGFloat = 20.0
        static let activityIndicatorSize: CGFloat = 60.0
    }
    
    /// Singleton
    static let sharedManager = LoadingManager()
    
    /// Background's dimming view's alpha
    var backgroundAlpha: CGFloat = 0.5 {
        didSet {
            dimmingBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
        }
    }
    
    /// Activity Indicator Color
    var loadingColor: [UIColor] = [.red]
    
    /// Horizontal inset. Left and Right inset
    var horizontalInset: CGFloat = 100
    
    /// Is the loading indicator being shown
    private(set) var isLoading: Bool = false
    
    /// Dimming background view
    private lazy var dimmingBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenWidth))
        view.backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private lazy var activityIndicator: DTCircularActivityIndicator = {
        let indicator = DTCircularActivityIndicator(frame: CGRect.zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    /// Label which displays the loading, success or error text.
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        return label
    }()
    
    /// ImageView to show successful or failure image
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var dimmingBackgroundViewContraints: [NSLayoutConstraint] = []
    
    
    /// Initilization
    private override init() {
        super.init()
        
        setup()
    }
    
    // MARK: Usage methods
    func showLoading(message: String) {
        if (!isLoading) {
            guard let window = UIWindow.currentWindow else { return }
            
            isLoading = true
            // TODO: Animating
            if !window.subviews.contains(dimmingBackgroundView) {
                window.addSubview(dimmingBackgroundView)
                
                dimmingBackgroundView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
                dimmingBackgroundView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
                dimmingBackgroundView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
                dimmingBackgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            }
        }
        
        label.text = message
        activityIndicator.startAnimating()
        showImageView(false)
    }
    
    func showError(message: String, dismissAfter interval: DispatchTimeInterval = .never) {
        showImageView(true, image: UIImage(named: "failed-icon"))
        activityIndicator.stopAnimating()
        label.text = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {[weak self] in
            self?.dismiss()
        }
    }
    
    func showSuccess(message: String, dismissAfter interval: DispatchTimeInterval = .never) {
        showImageView(true, image: UIImage(named: "success-icon"))
        activityIndicator.stopAnimating()
        label.text = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {[weak self] in
            self?.dismiss()
        }
    }
    
    // MARK: Private methods
    fileprivate func setup() {
            
        if !containerView.subviews.contains(activityIndicator) {
            containerView.addSubview(activityIndicator)
        }
        
        if !containerView.subviews.contains(label) {
            containerView.addSubview(label)
        }
        
        if !containerView.subviews.contains(imageView) {
            containerView.addSubview(imageView)
        }
        
        if !dimmingBackgroundView.subviews.contains(containerView) {
            dimmingBackgroundView.addSubview(containerView)
        }
        
        activityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: Dimemsion.activityIndicatorSize).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: Dimemsion.activityIndicatorSize).isActive = true
        
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Dimemsion.activityIndicatorSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Dimemsion.activityIndicatorSize).isActive = true
        
        label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20.0).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: dimmingBackgroundView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: dimmingBackgroundView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: dimmingBackgroundView.leadingAnchor, constant: horizontalInset).isActive = true
        containerView.trailingAnchor.constraint(equalTo: dimmingBackgroundView.trailingAnchor, constant: -horizontalInset).isActive = true
    }
    
    fileprivate func showImageView(_ show: Bool, image: UIImage? = nil) {
        imageView.isHidden = !show
        
        if let newImage = image {
            imageView.image = newImage
        }
    }
    
    fileprivate func dismiss() {
        dimmingBackgroundView.removeFromSuperview()
        isLoading = false
    }
}
