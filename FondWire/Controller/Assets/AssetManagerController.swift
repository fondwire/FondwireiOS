//
//  SelectAssetsController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/16/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import ProgressHUD
import FirebaseAuth



class AssetManagerController: UITableViewController {
    //MARK: - Properties
    
    private var searchIsActive = false
    private var filterManagers = [Asset]() {
        didSet {
            tableView.reloadData()
        }
    }
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool{
        return searchController.searchBar.text!.count > 0
    }
    
    var userPrefDict:[String: [String:[String]]]?
    var listOfSelectedAssets:[String]?
        
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let result = UserDefaults.standard.dictionary(forKey: "userInfo") as? [String: [String:[String]]] {
            userPrefDict = result
            print("DEBUG: \(userPrefDict)")
        }
        

        if let currentUser = DataService.shared.currentUser {
            guard let userDict = userPrefDict else { return }
            listOfSelectedAssets = userDict["\(currentUser.email)"]?["selectedAssets"]
        } else  {
            guard let userDict = userPrefDict else { return }
            listOfSelectedAssets = userDict["notUser"]?["selectedAssets"]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationItem.hidesBackButton = false
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        configureUI()
        configureSearchController()
        Vibration.success.vibrate()

    }

    //MARK: - Helpers
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for user"
        searchController.searchBar.tintColor = .darkGray
        searchController.searchBar.barTintColor = view.backgroundColor
        searchController.searchBar.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        definesPresentationContext = false
    }

    func configureUI() {
        view.autoresizesSubviews = false
        navigationItem.title = "ASSET MANAGER"
        tableView.register(AssetsTableCell.self, forCellReuseIdentifier: AssetsTableCell.reuseID)
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchTapped))
        navigationItem.rightBarButtonItem?.tintColor = .fwYellow
        navigationItem.leftBarButtonItem?.tintColor = .lightText
        self.searchController.searchBar.isHidden = true
    }
    
    //MARK: - Selectors
    @objc func handleSearchTapped() {
        if !searchIsActive {
            self.searchController.searchBar.isHidden = false
            tableView.tableHeaderView = searchController.searchBar
            searchIsActive.toggle()
            searchController.searchBar.becomeFirstResponder()
        } else {
            self.searchController.searchBar.isHidden = true
            tableView.tableHeaderView = nil
            searchIsActive.toggle()
        }
    }
}

extension AssetManagerController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterManagers.count : DataService.shared.assets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssetsTableCell.reuseID, for: indexPath) as! AssetsTableCell
        let asset = inSearchMode ? filterManagers[indexPath.row] : DataService.shared.assets[indexPath.row]
        cell.asset = asset
        cell.delegate = self
        cell.indexPath = indexPath
        
        if let selectedAssets = listOfSelectedAssets {
            for selectedAsset in selectedAssets {
                if selectedAsset.lowercased() == asset.name.lowercased() {
                    cell.followButton.isSelected = true
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let asset = inSearchMode ? filterManagers[indexPath.row] : DataService.shared.assets[indexPath.row]
        let storyboard = UIStoryboard(name: "AssetDetailController", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "AssetDetailController") as! AssetDetailController
        controller.modalPresentationStyle = .formSheet
        controller.asset = asset
        present(controller, animated: true, completion: nil)
    }
    
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessoryType = .disclosureIndicator
    }
    

    
}

extension AssetManagerController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterManagers = DataService.shared.assets.filter({ $0.name.lowercased().contains(searchText) })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        handleSearchTapped()
    }
}

extension AssetManagerController: AssetsTableCellDelegate {
    func followButtonTapped(withIndexPath indexPath: IndexPath, selected: Bool) {
    
        if var selectedAssets = listOfSelectedAssets
        {
        if !selectedAssets.contains(DataService.shared.assets[indexPath.row].name) {
            selectedAssets.append(DataService.shared.assets[indexPath.row].name)
        } else {
            guard let index = selectedAssets.firstIndex(of: DataService.shared.assets[indexPath.row].name) else { return }
            selectedAssets.remove(at: index)
        }
        
        
        let userPreferences = ["selectedAssets": selectedAssets]
       
        if let currentUser = DataService.shared.currentUser {
            let userInfo = ["\(currentUser.email)": userPreferences]
            UserDefaults.standard.set(userInfo, forKey: "userInfo")
        } else {
            let userInfo = ["notUser": userPreferences]
            UserDefaults.standard.set(userInfo, forKey: "userInfo")
        }
        }

    }
}
