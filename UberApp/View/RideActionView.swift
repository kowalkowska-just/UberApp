//
//  RideActionView.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 14/11/2020.
//

import UIKit
import MapKit

//MARK: - Protocols

protocol RideActionViewDelegate: class {
    func uploadTrip(_ view: RideActionView)
}

enum RideActionViewConfiguration {
    case requestRider
    case tripAccepted
    case pickupMessenger
    case tripInProgress
    case endTrip
    
    init() {
        self = .requestRider
    }
}

enum ButtonAction: CustomStringConvertible {
    case requestRide
    case cancelRide
    case getDirections
    case pickup
    case dropOff
    
    var description: String {
        switch self {
        case .requestRide: return "CONFIRM UBERX"
        case .cancelRide: return "CANCEL RIDE"
        case .getDirections: return "GET DIRECTIONS"
        case .pickup: return "PICKUP PASSENGER"
        case .dropOff: return "DROP OFF PASSENGER"
        }
    }
    init() {
        self = .requestRide
    }
}

class RideActionView: UIView {

//MARK: - Properties
    
    var placemark: MKPlacemark? {
        didSet {
            titleLabel.text = placemark?.name
            addressLabel.text = placemark?.address
        }
    }
    
    var config = RideActionViewConfiguration()
    var buttonAction = ButtonAction()
    
    weak var delegate: RideActionViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center

        return label
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.text = "X"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .center
        
        view.addSubview(label)
        label.centerX(inView: view)
        label.centerY(inView: view)
        
        return view
    }()
    
    private let uberXLabel: UILabel = {
        let label = UILabel()
        label.text = "UberX"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("CONFIRM UBERX", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
//MARK: - Selectors
    
    @objc func actionButtonPressed() {
        delegate?.uploadTrip(self)
    }

//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(top: topAnchor, paddingTop: 15)
        stack.centerX(inView: self)
        
        addSubview(infoView)
        infoView.anchor(top: stack.bottomAnchor, paddingTop: 15,
                        width: 60, height: 60)
        infoView.centerX(inView: self)
        infoView.layer.cornerRadius = 60 / 2
        
        addSubview(uberXLabel)
        uberXLabel.anchor(top: infoView.bottomAnchor, paddingTop: 8)
        uberXLabel.centerX(inView: self)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: uberXLabel.bottomAnchor, left: leftAnchor,
                             right: rightAnchor, paddingTop: 4, height: 0.5)
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingBottom: 24, paddingRight: 12, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Helper Functions
    
    func configureUI(withConfiguration config: RideActionViewConfiguration) {
        switch config {
        case .requestRider:
            break
        case .tripAccepted:
            titleLabel.text = "En Route To Passenger"
            buttonAction = .getDirections
            actionButton.setTitle(buttonAction.description, for: .normal)
        case .pickupMessenger:
            break
        case .tripInProgress:
            break
        case .endTrip:
            break
        }
    }
}
