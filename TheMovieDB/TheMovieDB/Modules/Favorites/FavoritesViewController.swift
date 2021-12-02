//
//  FavoritesViewController.swift
//  TheMovieDB
//
//  Created by user on 25.11.2021.
//

import UIKit
import CoreData

protocol FavoritesViewControllerProtocol: AnyObject {
    var presenter: FavoritesPresenterProtocol? { get set }
    
    func reloadData()
}

final class FavoritesViewController: UIViewController {
    
    var presenter: FavoritesPresenterProtocol?
    var fetchedResultsController: NSFetchedResultsController<Favorite>?
    
    private let tableView: UITableView = {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.identifier)
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configure()
        setupFetchedResultsController()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController as? StatusBarStyleNavigationController else { return }
        navigationController.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController.navigationBar.shadowImage = nil
        navigationController.navigationBar.tintColor = .systemBlue
        navigationController.statusBarEnterLightBackground()
    }
    
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request, managedObjectContext: PersistentService.shared.coreDataStack.viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        guard let fetchedResultsController = fetchedResultsController else { return }
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let addFavButton = UIBarButtonItem(
            image: UIImage(systemName: "trash.circle"), style: .plain,
            target: self, action: #selector(deleteAllFav))
        
        navigationItem.rightBarButtonItem = addFavButton
        
    }
    
    @objc private func deleteAllFav() {
        let alert = UIAlertController(title: "Вы уверены?", message: "вы уверены, что хотите очитсть избранное?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.presenter?.deleteAllFavorite()
        }
        let cancelAction =  UIAlertAction(title: "Отмена", style: .default)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension FavoritesViewController: FavoritesViewControllerProtocol {
    func reloadData() {
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            break
        case .move:
            break
        @unknown default:
            fatalError()
            
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.identifier, for: indexPath) as? FavoritesCell else {
            fatalError()
        }
        guard let favorite = fetchedResultsController?.object(at: indexPath) else { fatalError() }
        cell.configure(with: favorite)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let favorite = fetchedResultsController?.object(at: indexPath) else { fatalError() }
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            presenter?.deleteFavorite(id: Int(favorite.id))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let seletItem = fetchedResultsController?.sections?[indexPath.section].objects?[indexPath.item] as? Favorite else { return }
        presenter?.presentMovieScreen(from: self, for: Int(seletItem.id))
    }
}
