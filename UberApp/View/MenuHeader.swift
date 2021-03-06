//
//  File.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 21/11/2020.
//

import UIKit

class MenuHeader: UIView {
    
// MARK: - Properties
    
    private let user: User
    
    private lazy var initialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 42)
        label.textColor = .white
        label.text = user.firstInitial
        return label
    }()
    
    private lazy var profileImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        view.addSubview(initialLabel)
        initialLabel.centerX(inView: view)
        initialLabel.centerY(inView: view)
        return view
    }()
    
    private lazy var fullnameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = user.fullname
        return label
    }()
    
    private lazy var emailLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = user.email
        return label
    }()
    
    private let pickupModeLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "PICKUP MODE ENABLED"
        return label
    }()
    
    private let pickupSwitch: UISwitch = {
        let switchUI = UISwitch(frame: CGRect.zero)
        switchUI.addTarget(self, action: #selector(handleChangedSwitch), for: .valueChanged)
        switchUI.tintColor = .systemBlue
        switchUI.isOn = true
        switchUI.onTintColor = .onTint
        switchUI.layer.cornerRadius = 16
        switchUI.backgroundColor = .offTint
        
        return switchUI
    }()
    
    

// MARK: - Lifecycle
    
    init(user: User, frame: CGRect) {
        self.user = user
        super.init(frame: frame)
        
        backgroundColor = .backgroundColor
    
        addSubview(profileImageView)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,
                                paddingTop: 5, paddingLeft: 12,
                                width: 64, height: 64)
        profileImageView.layer.cornerRadius = 64 / 2
        
        let stack = UIStackView(arrangedSubviews: [fullnameLable, emailLable])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        stack.centerY(inView: profileImageView)
        
        addSubview(pickupModeLable)
        pickupModeLable.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 12)
        
        addSubview(pickupSwitch)
        pickupSwitch.anchor(top: pickupModeLable.bottomAnchor, paddingTop: 5)
        pickupSwitch.centerX(inView: profileImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Selectors
    
    @objc func handleChangedSwitch() {
        print("DEBUG: Changed switch value...")
    }
}
