//
//  LocationInputView.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 09/11/2020.
//

import UIKit

protocol LocationInputViewDelegate: class {
    func dismissLocationInput()
}

class LocationInputView: UIView {

//MARK: - Proporties
    
    weak var delegate: LocationInputViewDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 25)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - Selectors
    
    @objc func handleBackTapped() {
        delegate?.dismissLocationInput()
    }
    
}
