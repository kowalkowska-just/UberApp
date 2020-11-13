//
//  HomeController.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 09/11/2020.
//

import UIKit
import Firebase
import MapKit

private let reuseIdentifier = "LocationCell"
private let annotationIdentifier = "DriverAnnotation"

private enum ActionButtonConfiguration {
    case showMenu
    case dismissActionView
    
    init() {
        self = .showMenu
    }
}

class HomeController: UIViewController {
    
//MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private var searchResults = [MKPlacemark]()
    private final let locationInputViewHeight: CGFloat = 200
    private var actionButtonConfig = ActionButtonConfiguration()

    private var user: User? {
        didSet { locationInputView.user = user }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "menu-icon"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationServices()

//        signOut()
    }
    
//MARK: - Selectors
    @objc func actionButtonPressed() {
        
        switch actionButtonConfig {
        case .dismissActionView:

            mapView.annotations.forEach { (annotation) in
                if let anno = annotation as? MKPointAnnotation {
                    mapView.removeAnnotation(anno)
                }
            }
            
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
                self.configureActionButton(config: .showMenu)
            }
            
        case .showMenu:
            print("DEBUG: Handle show menu.")
        }
    }
    
//MARK: - API
    
    func fetchUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.shered.fetchUserData(uid: currentUid) { (user) in
            self.user = user
        }
    }
    
    func fetchDrivers() {
        guard let location = locationManager?.location else { return }
        Service.shered.fetchDrivers(location: location) { (driver) in
            guard let coordinate = driver.location?.coordinate else { return }
            let annotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            
            var driverIsVisible: Bool {
                return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                    guard let driverAnnotation = annotation as? DriverAnnotation else { return false }
                    if driverAnnotation.uid == driver.uid {
                        driverAnnotation.updateAnnotationPosition(withCoordinate: coordinate)
                        return true
                    }
                    return false
                })
            }
            
            if !driverIsVisible {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
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
            configure()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } catch {
            print("DEBUG: Error signing out.")
        }
    }
    
//MARK: - Helper Functions
    
    func configure() {
        configureUI()
        fetchUserData()
        fetchDrivers()
    }
    
    fileprivate func configureActionButton(config: ActionButtonConfiguration) {
        switch config {
        case .dismissActionView:
            self.actionButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.actionButtonConfig = .dismissActionView
        case .showMenu:
            self.actionButton.setImage(UIImage(named: "menu-icon"), for: .normal)
            self.actionButtonConfig = .showMenu
        }
    }
    
    func configureUI() {
        configureMapView()
        
        view.backgroundColor = .backgroundColor

        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 20, width: 25, height: 25)
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.anchor(top: actionButton.bottomAnchor, paddingTop: 32, width: view.frame.width - 64, height: 50)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
        
        configureTableView()
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    func configureLocationInputView() {
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0
        locationInputView.delegate = self
        
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { (_) in
            print("DEBUG: Present table view..")
            self.displayTableView()
        }
    }
    
    func displayTableView() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame.origin.y = self.locationInputViewHeight
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height,
                                 width: view.frame.width, height: height)
        
        view.addSubview(tableView)
    }
    
    func dismissLocationView(completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
            self.locationInputView.removeFromSuperview()
        }, completion: completion)
    }
}

//MARK: - Map Helper Functions

private extension HomeController {
    
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            
            response.mapItems.forEach { (item) in
                print("DEBUG: Item is \(item.name)")
                results.append(item.placemark)
            }
            completion(results)
        }
    }
}

//MARK: - MKMapViewDelegate

extension HomeController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = UIImage(named: "driver-icon-2")
            return view
        }
        return nil
    }
}

//MARK: - LocationServices

extension HomeController {
    
    func enableLocationServices() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: Not determined..")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied: break
        case .authorizedAlways:
            print("DEBUG: Authorization always..")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Authorization when in use..")
            locationManager?.requestAlwaysAuthorization()
        @unknown default: break
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
    func dismissLocationInputView() {
        dismissLocationView { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.inputActivationView.alpha = 1
            })
        }
    }
    
    
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { (results) in
            print("DEBUG: Placemark is \(results)")
            self.searchResults = results
            self.tableView.reloadData()
        }
    }
}

//MARK: - TableView - Delegate - DataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
        //return section == 0 ? ifTrue : ifFalse
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        
        if indexPath.section == 1 {
        cell.placemark = searchResults[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPlacemark = searchResults[indexPath.row]

        configureActionButton(config: .dismissActionView)
        
        dismissLocationView { (_) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
}
