//
//  Extensions.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import UIKit


fileprivate var containerView: UIView!

//MARK: - UIViewController EXTENSION
extension UIViewController {
    
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            if message != ACLabel.cancelled {
                let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertVC.modalPresentationStyle  = .overFullScreen
                alertVC.modalTransitionStyle    = .crossDissolve
                
                let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
                alertVC.addAction(action)
                
                self.present(alertVC, animated: true)
            }
        }
    }

    func showLoading(in view: UIView, backgroundAlpha: Double = 0.8) {
        guard containerView == nil else { return }
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.bringToFront()
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = backgroundAlpha }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
}



//MARK: - UITextField EXTENSION
extension UITextField {
    func addKeyboardToolBar(leftButtons: [KeyboardToolbarButton], rightButtons: [KeyboardToolbarButton], toolBarDelegate: KeyboardToolbarDelegate) {
        let toolbar = KeyboardToolbar(for: self, toolBarDelegate: toolBarDelegate)
        toolbar.setup(leftButtons: leftButtons, rightButtons: rightButtons)
    }
}


//MARK: - UIView EXTENSION
extension UIView {
    
    func addSubviews(_ views: UIView...) { for view in views { addSubview(view) } }
    
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.9).cgColor]
        layer.addSublayer(gradientLayer)
    }
    
    func addBlurBG(effect: UIBlurEffect.Style = .regular, with background: UIImage? = nil) {
        let blurEffect = UIBlurEffect(style: effect)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.tag = 305
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        if let background = background {
            let imageView = UIImageView(image: background)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = bounds
            addSubview(imageView)
            imageView.sendToBack()
        }
    }
    
    func sendToBack()   { DispatchQueue.main.async { self.superview?.sendSubviewToBack(self) } }
    func bringToFront() { DispatchQueue.main.async { self.superview?.bringSubviewToFront(self) } }
    
}
