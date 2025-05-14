//
//  ViewController.swift
//  Weather
//
//  Created by hai.nguyenv on 5/12/25.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbNoData: UILabel!
    
    let searchBar = UISearchBar()
    
    var searchResults: [String] = []
    var recentSearch: [String] = CachingManager.shared.getRecentSearch()
    
    let debouncer = Debouncer(delay: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchBar()
        setNoData()
    }
    private func setupSearchBar() {
        searchBar.placeholder = "Input a city"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    private func setNoData(){
        if recentSearch.count == 0 && searchResults.count == 0 {
            self.lbNoData.isHidden = false
        }else{
            self.lbNoData.isHidden = true
        }
    }
    
    private func performSearch(_ keywork: String) {
        debouncer.run {
            APIManager.shared.searchCity(query: keywork) { results in
                DispatchQueue.main.async {
                    self.searchResults = results
                    self.setNoData()
                    self.tableView.reloadData()
                }
            }
        }
    }
    private func showWeatherByCity(for city: String) {
        CachingManager.shared.addCity(city)
        let view = CityDetailView(cityName: city)
        let vc = UIHostingController(rootView: view)
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
            recentSearch = CachingManager.shared.getRecentSearch()
            tableView.reloadData()
            setNoData()
        } else {
            performSearch(searchText)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBar.text?.isEmpty == false ? searchResults.count : recentSearch.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cities = searchBar.text?.isEmpty == false ? searchResults : recentSearch
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cities = searchBar.text?.isEmpty == false ? searchResults : recentSearch
        showWeatherByCity(for: cities[indexPath.row])
    }
}
