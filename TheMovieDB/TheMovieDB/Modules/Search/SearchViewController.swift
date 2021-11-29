//
//  SearchViewController.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    var placeholderLabel: UILabel { get }
    
    var presenter: SearchPresenterProtocol? { get set }
    var searchResults: [SearchMovie] { get set }
}

final class SearchViewController: UIViewController {
    private var timer: Timer?
    private let searchController = UISearchController(searchResultsController: nil)
    
    var presenter: SearchPresenterProtocol?
    var searchResults = [SearchMovie]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    let placeholderLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 14, weight: .bold))
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Пожалуйста, введите поисковый запрос..."
        return $0
    }(UILabel())
    
    private let tableView: UITableView = {
        $0.allowsSelection = false
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        return $0
    }(UITableView())
    
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
            placeholderLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -8),
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        let searchMovie = searchResults[indexPath.row]
        cell.configure(with: searchMovie)
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            placeholderLabel.text = "Пожалуйста, введите поисковый запрос..."
        }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
            self?.presenter?.searchMovie(name: searchText)
        })
    }
}

extension SearchViewController: SearchViewControllerProtocol {}
