//
//  MovieViewController.swift
//  TheMovieDB
//
//  Created by user on 01.11.2021.
//

import UIKit

protocol MovieViewControllerProtocol: AnyObject {
    var presenter: MoviePresenterProtocol? { get set }
    var movieDetail: MovieDetailResponse? { get set }
}

final class MovieViewController: IndicationViewController {
    var presenter: MoviePresenterProtocol?
    var movieDetail: MovieDetailResponse? { didSet { configureTable() } }
    
    private let movieId: Int
    private let mediaType: MediaType
    private let imageNetworkService: ImageLoadServiceProtocol = ImageLoadService.shared
    private var headerNavigationBarStyleisHeader: Bool = true
    
    private let tableView: UITableView = {
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MovieDetail.self, forCellReuseIdentifier: MovieDetail.identifier)
        return $0
    }(UITableView())
    
    init(movieId: Int, mediaType: MediaType) {
        self.movieId = movieId
        self.mediaType = mediaType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        presenter?.loadData(movieId: movieId, mediaType: mediaType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController as? StatusBarStyleNavigationController else { return }
        navigationController.statusBarEnterDarkBackground()
    }

    private func configure() {
        configureNavigationBar(tintColor: .white, backgroundImage: UIImage())
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let rightButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareMovie))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = StretchyTableHeader(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 350))
        self.tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        guard let movieDetail = movieDetail else { return }
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(movieDetail.posterPath)"
        
        imageNetworkService.getImageFrom(imageUrlString) { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                headerView.imageView.image = image
            }
        }
    }
    
    private func configureNavigationBar(tintColor: UIColor, backgroundImage: UIImage?) {
        let animation = CATransition()
        animation.duration = 0.2
        navigationController?.navigationBar.layer.add(animation, forKey: nil)
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = backgroundImage
    }
    
    @objc private func shareMovie() {
        self.showAlert(title: "111", message: "222")
    }
}

extension MovieViewController: MovieViewControllerProtocol { }

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let movieDetail = movieDetail,
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetail.identifier, for: indexPath) as? MovieDetail
        else { fatalError() }
        cell.configure(movieDetail: movieDetail)
        return cell
    }
}

extension MovieViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.tableView.tableHeaderView as? StretchyTableHeader else { return }
        guard let movieDetail = movieDetail else { return }
        guard let navigationBarHeight = navigationController?.navigationBar.frame.maxY else { return }
        guard let navigationController = navigationController as? StatusBarStyleNavigationController else { return }
        
        headerView.scrollViewDidScroll(scrollView: scrollView)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
        let cellYPosition = rectOfCellInSuperview.origin.y
        
        if cellYPosition <= navigationBarHeight, headerNavigationBarStyleisHeader {
            self.title = movieDetail.title
            configureNavigationBar(tintColor: .black, backgroundImage: nil)
            headerNavigationBarStyleisHeader = !headerNavigationBarStyleisHeader
            navigationController.statusBarEnterLightBackground()
        } else if cellYPosition > navigationBarHeight, !headerNavigationBarStyleisHeader {
            self.title = nil
            configureNavigationBar(tintColor: .white, backgroundImage: UIImage())
            headerNavigationBarStyleisHeader = !headerNavigationBarStyleisHeader
            navigationController.statusBarEnterDarkBackground()
        }
    }
}
