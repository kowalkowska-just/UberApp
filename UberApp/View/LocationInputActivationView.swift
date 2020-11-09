//
//  LocationInputActivationView.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 09/11/2020.
//

import UIKit

protocol LocationInputActivationViewDelegate: class {
    func presentLocationInputView()
}

class LocationInputActivationView: UIView {
    
//MARK: - Properties
    
    weak var delegate: LocationInputActivationViewDelegate?
    
    private let indecatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.darkGray
        return label
    }()
    
//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
        
        
        addSubview(indecatorView)
        indecatorView.anchor(left: leftAnchor, paddingLeft: 16, width: 6, height: 6)
        indecatorView.centerY(inView: self)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(left: indecatorView.rightAnchor, paddingLeft: 20)
        placeholderLabel.centerY(inView: self)
        
        isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentLocationInputView))
    //    tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - Selectors
    
    @objc func presentLocationInputView() {
        print("tap")
        delegate?.presentLocationInputView()
    }
    
}
