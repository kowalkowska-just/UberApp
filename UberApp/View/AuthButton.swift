//
//  AuthButton.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 06/11/2020.
//

import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    
    setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
    titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    backgroundColor = .mainBlueTint
    layer.cornerRadius = 5
    anchor(height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
