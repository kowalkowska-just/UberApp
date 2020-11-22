//
//  AddLocationController.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 22/11/2020.
//

import UIKit
import MapKit

private let reuseIdentifier = "Cell"

protocol AddLocationControllerDelegate: class {
    func updateLocation(locationString: String, type: LocationType)
}

class AddLocationController: UITableViewController {
    
//MARK: - Properties
    
    weak var delegate: AddLocationControllerDelegate?
    
    private let searchBar = UISearchBar()
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]() {
        didSet { tableView.reloadData() }
    }
    private let type: LocationType
    private let location: CLLocation
    
//MARK: - Lifecycle
    
    init(type: LocationType, location: CLLocation) {
        self.type = type
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationController()
        configureSearchBar()
        configureSearchCompleter()
        
        print("DEBUG: Type is \(type.description)")
        print("DEBUG: Location is \(location)")
    }
    
//MARK: - Helper functions
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        
        tableView.addShadow()
    }
    
    func configureNavigationController() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .backgroundColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(handleDismissal))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func configureSearchCompleter() {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        searchCompleter.region = region
        searchCompleter.delegate = self
    }
    
//MARK: - Selectors
    
    @objc func handleDismissal() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDelegate/DataSource

extension AddLocationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let results = searchResults[indexPath.row]
        cell.textLabel?.text = results.title
        cell.detailTextLabel?.text = results.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let results = searchResults[indexPath.row]
        let title = results.title
        let subtitle = results.subtitle
        let locationString = title + " " + subtitle
        let trimmedLocation = locationString.replacingOccurrences(of: ", Poland", with: "")
        delegate?.updateLocation(locationString: trimmedLocation, type: type)
    }
}

//MARK: - UISearchBarDelegate

extension AddLocationController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

//MARK: - MKLocalSearchCompleterDelegate

extension AddLocationController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}
