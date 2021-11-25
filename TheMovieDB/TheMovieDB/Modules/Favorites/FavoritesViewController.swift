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
}

final class FavoritesViewController: UIViewController {
    
    var presenter: FavoritesPresenterProtocol?
    var fetchedResultsController: NSFetchedResultsController<Favorite>?
    
    private let tableView: UITableView = {
        $0.allowsSelection = false
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configure()
        setupFetchedResultsController()
        tableView.reloadData()
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
    }
}

extension FavoritesViewController: FavoritesViewControllerProtocol {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let favorite = fetchedResultsController?.object(at: indexPath) else { fatalError() }
        cell.textLabel?.text = favorite.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let favorite = fetchedResultsController?.object(at: indexPath) else { fatalError() }
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            presenter?.deleteFavorite(id: Int(favorite.id))
        }
    }
}
