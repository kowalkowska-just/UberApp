//
//  HomeController.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 09/11/2020.
//

import UIKit
import Firebase
import MapKit

class HomeController: UIViewController {
    
//MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationServices()
//        signOut()
        view.backgroundColor = .backgroundColor
    }
    
//MARK: - API
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User not logged in...")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            print("DEBUG: User's id is \(String(describing: Auth.auth().currentUser?.uid))")
            configureUI()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Error signing out.")
        }
    }
    
//MARK: - Helper Functions
    
    func configureUI() {
        configureMapView()
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32 ,width: view.frame.width - 64, height: 50)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func configureLocationInputView() {
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
        locationInputView.alpha = 0
        locationInputView.delegate = self
        
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { (_) in
            print("DEBUG: Present table view..")
        }
    }
}

//MARK: - LocationServices

extension HomeController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: Not determined..")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied: break
        case .authorizedAlways:
            print("DEBUG: Authorization always..")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Authorization when in use..")
            locationManager.requestAlwaysAuthorization()
        @unknown default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
}

//MARK: - LocationInputActivationViewDelegate

extension HomeController: LocationInputActivationViewDelegate {
    func presentLocationInputView() {
        print("DEBUG: Handle present location input view..")
        inputActivationView.alpha = 0
        configureLocationInputView()
    }
}

//MARK: - LocationInputViewDelegate

extension HomeController: LocationInputViewDelegate {
    func dismissLocationInput() {
        print("DEBUG: Dismiss view..")
        
        UIView.animate(withDuration: 0.3) {
            self.locationInputView.alpha = 0
        } completion: { (_) in
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }
    }
}
