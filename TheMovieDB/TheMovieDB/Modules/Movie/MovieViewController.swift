//
//  MovieViewController.swift
//  TheMovieDB
//
//  Created by user on 01.11.2021.
//

import UIKit

protocol MovieViewControllerProtocol {}

final class MovieViewController: UIViewController {
    
    let movie: Movie
    
    private let tableView: UITableView = {
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return $0
    }(UITableView())
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let rightButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareMovie))
        navigationItem.rightBarButtonItem = rightButton
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = StretchyTableHeader(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250))
        headerView.imageView.image = UIImage(named: "backdrop_placeholder")
        self.tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureNavigationBar(tintColor: UIColor, barStyle: UIBarStyle, backgroundImage: UIImage, backgroundColor: UIColor) {
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.barStyle = barStyle
        navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = backgroundImage
        navigationController?.navigationBar.backgroundColor = backgroundColor
    }
    
    @objc private func shareMovie() {
        print(#function)
    }
}

extension MovieViewController: UITableViewDelegate {
    
}

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

extension MovieViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.tableView.tableHeaderView as? StretchyTableHeader else { return }
        headerView.scrollViewDidScroll(scrollView: scrollView)
        
        guard let navigationBarHeight = navigationController?.navigationBar.frame.maxY else { return }
        let indexPath = IndexPath(row: 0, section: 0)
        let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
        let cellY = rectOfCellInSuperview.origin.y
        
        if cellY <= navigationBarHeight {
            self.title = movie.title ?? movie.name
            headerView.imageView.isHidden = true
            configureNavigationBar(tintColor: .black, barStyle: .default, backgroundImage: UIColor.white.image(), backgroundColor: .white)
        } else {
            self.title = nil
            headerView.imageView.isHidden = false
            configureNavigationBar(tintColor: .white, barStyle: .black, backgroundImage: UIImage(), backgroundColor: .clear)
        }
    }
}
