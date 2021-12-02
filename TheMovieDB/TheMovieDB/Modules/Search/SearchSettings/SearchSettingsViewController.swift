//
//  SearchSettingsViewController.swift
//  TheMovieDB
//
//  Created by user on 01.12.2021.
//

import UIKit

protocol SearchSettingsViewControllerProtocol: AnyObject {
    var presenter: SearchSettingsPresenterProtocol? { get set }
}

final class SearchSettingsViewController: UIViewController {
    var presenter: SearchSettingsPresenterProtocol?
    
    private let tableView: UITableView = {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        $0.backgroundColor = .clear
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        title = "Настройки поиска"
        
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

extension SearchSettingsViewController: SearchSettingsViewControllerProtocol {
    @objc func adultSwitchTriggered(sender: UISwitch) {
        presenter?.setAdultFillter(sender.isOn)
    }
}

extension SearchSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension SearchSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Показывать фильмы 18+"
        let adultSwitch = UISwitch()
        adultSwitch.isOn = presenter?.getAdultFillter() ?? false
        adultSwitch.addTarget(self, action: #selector(adultSwitchTriggered), for: .valueChanged)
        cell.accessoryView = adultSwitch
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        return cell
    }
}
