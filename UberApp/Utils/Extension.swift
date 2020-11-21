//
//  Extension.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 06/11/2020.
//

import UIKit
import MapKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
    static let mainBlueTint = UIColor.rgb(red: 17, green: 154, blue: 237)
    static let onTint = UIColor.rgb(red: 26, green: 188, blue: 156)
    static let offTint = UIColor.rgb(red: 231, green: 76, blue: 60)
}

extension UIView {
    
    func inputContainerView(image: UIImage, textField: UITextField? = nil, segmentedControl: UISegmentedControl? = nil) -> UIView {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .white
        imageView.alpha = 0.87
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        
        if let textField = textField {
            imageView.anchor(left: view.leftAnchor, paddingLeft: 8,
                             width: 24, height: 24)
            imageView.centerY(inView: view)
            
            view.addSubview(textField)
            textField.anchor(left: imageView.rightAnchor, right: view.rightAnchor,
                             paddingLeft: 8, paddingRight: 8)
            textField.centerY(inView: view)
        }
        
        if let sc = segmentedControl {
            imageView.anchor(top: view.topAnchor, left: view.leftAnchor,
                             paddingTop: -8, paddingLeft: 8, width: 24, height: 24)
            
            view.addSubview(sc)
            sc.anchor(left: view.leftAnchor, right: view.rightAnchor,
                      paddingLeft: 8, paddingRight: 8)
            sc.centerY(inView: view, constant: 8)
        }
        
        let separationView = UIView()
        separationView.backgroundColor = .lightGray
        view.addSubview(separationView)
        separationView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                              paddingLeft: 8, paddingRight: 8, height: 0.75)
        
        return view
    }

    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }
    
    func centerY(inView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
}

extension UITextField {
    
    func textField(withPlaceholder placeholder: String, isSecureTextEntry: Bool) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.isSecureTextEntry = isSecureTextEntry
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .white
        tf.keyboardAppearance = .dark
        
        return tf
    }
}

extension MKPlacemark {
    var address: String? {
        get {
            guard let subThoroughfare = subThoroughfare else { return nil }
            guard let thoroughfare = thoroughfare else { return nil }
            guard let locality = locality else { return nil }
            guard let adminArea = administrativeArea else { return nil }
            
            return "\(thoroughfare) \(subThoroughfare), \(locality), \(adminArea)"
        }
    }
}

extension MKMapView {
    func zoomToFit(annotation: [MKAnnotation]) {
        var zoomRect = MKMapRect.null
        annotation.forEach { (annotation) in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y,
                                      width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insets = UIEdgeInsets(top: 75, left: 75, bottom: 300, right: 100)
        setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
    }
    
    func addAnnotationAndSelect(forCoordinate coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        addAnnotation(annotation)
        selectAnnotation(annotation, animated: true)
    }
}

extension UIViewController {
    
    func presentAlertController(withTitle title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func shouldPresentLoadingView(_ present: Bool, message: String? = nil) {
        if present {
            let loadingView = UIView()
            loadingView.frame = self.view.frame
            loadingView.backgroundColor = .backgroundColor
            loadingView.alpha = 0
            loadingView.tag = 1

            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .white
            indicator.center = view.center
            
            let label = UILabel()
            label.text = message
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .white
            label.alpha = 0.87
            
            view.addSubview(loadingView)
            loadingView.addSubview(indicator)
            loadingView.addSubview(label)
            
            label.anchor(top: indicator.bottomAnchor, paddingTop: 32)
            label.centerX(inView: view)
            
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.3) {
                loadingView.alpha = 0.7
            }
        } else {
            view.subviews.forEach { (subview) in
                if subview.tag == 1 {
                    UIView.animate(withDuration: 0.3) {
                        subview.alpha = 0
                    } completion: { (_) in
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
}
