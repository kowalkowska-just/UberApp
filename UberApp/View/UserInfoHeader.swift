//
//  UserInfoHeader.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 22/11/2020.
//

import UIKit

class UserInfoHeader: UIView {
    
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
        label.textColor = .black
        label.text = user.fullname
        return label
    }()
    
    private lazy var emailLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = user.email
        return label
    }()

// MARK: - Lifecycle
        
    init(user: User, frame: CGRect) {
        self.user = user
        super.init(frame: frame)
            
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 16, width: 64, height: 64)
        profileImageView.centerY(inView: self)
        profileImageView.layer.cornerRadius = 64 / 2
            
        let stack = UIStackView(arrangedSubviews: [fullnameLable, emailLable])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
            
        addSubview(stack)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        stack.centerY(inView: profileImageView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
