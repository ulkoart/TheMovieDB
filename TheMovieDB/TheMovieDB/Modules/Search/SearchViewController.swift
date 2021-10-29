//
//  SearchViewController.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import UIKit

protocol SearchViewControllerProtocol {
    var presenter: SearchPresenterProtocol? { get set }
    var searchResults: [SearchMovie] { get set }
}

final class SearchViewController: UIViewController {
    private var timer: Timer?
    private let searchController = UISearchController(searchResultsController: nil)
    
    var presenter: SearchPresenterProtocol?
    var searchResults = [SearchMovie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let placeholderLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 14, weight: .bold))
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Пожалуйста, введите поисковый запрос..."
        return $0
    } (UILabel())
    
    private let tableView: UITableView = {
        $0.allowsSelection = false
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return $0
    } (UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Название фильма")
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        self.definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: view.topAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placeholderLabel.isHidden = !searchResults.isEmpty
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let searchMovie = searchResults[indexPath.row]
        cell.textLabel?.text = "\(searchMovie.title) \(searchMovie.releaseDate)"
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else { searchResults = []; return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.presenter?.searchMovie(name: searchText)
        })
    }
}

extension SearchViewController: SearchViewControllerProtocol {

}
