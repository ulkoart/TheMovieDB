//
//  MovieViewController.swift
//  TheMovieDB
//
//  Created by user on 01.11.2021.
//

import UIKit
import StretchyTableHeader

protocol MovieViewControllerProtocol: AnyObject {
    var presenter: MoviePresenterProtocol? { get set }
    
    func configureData(movieDetail: MovieDetailResponse, movieCredits: MovieCreditsResponse)
    func reloadData()
    func dataFailure(text: String)
    func switchFavouritesIcon()
}

final class MovieViewController: IndicationViewController {
    var presenter: MoviePresenterProtocol?
    
    private let movieId: Int
    private var movieDetail: MovieDetailResponse?
    private var movieCredits: MovieCreditsResponse?
    private var tableHeaderIsHidden: Bool = false
    private let imageNetworkService: ImageLoadServiceProtocol = ImageLoadService.shared
    
    private let tableView: UITableView = {
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(СinemaInfo.self, forCellReuseIdentifier: СinemaInfo.identifier)
        $0.register(СinemaOverview.self, forCellReuseIdentifier: СinemaOverview.identifier)
        $0.register(СinemaVote.self, forCellReuseIdentifier: СinemaVote.identifier)
        $0.register(CastsCell.self, forCellReuseIdentifier: CastsCell.identifier)
        $0.register(CrewsCell.self, forCellReuseIdentifier: CrewsCell.identifier)
        return $0
    }(UITableView())
    
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        presenter?.loadData(movieId: movieId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController as? StatusBarStyleNavigationController else { return }
        navigationController.statusBarEnterDarkBackground()
    }
    
    private func configure() {
        let headerView = StretchyTableHeader(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 350))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        configureNavigationBarStyle(tintColor: .white, backgroundImage: UIImage())
        configureNavigationBarItems()
    }
    
    private func configureNavigationBarItems() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareMovie))
        
        var addFavButtonImageSystemName = "heart"
        if presenter?.movieIsFavorite(id: movieId) == true {
            addFavButtonImageSystemName += ".fill"
        }
        
        let addFavButton = UIBarButtonItem(
            image: UIImage(systemName: addFavButtonImageSystemName), style: .plain,
            target: self, action: #selector(favouriteTapped))
        
        navigationItem.rightBarButtonItems = [shareButton, addFavButton]
    }
    
    private func configureNavigationBarStyle(tintColor: UIColor, backgroundImage: UIImage?) {
        let animation = CATransition()
        animation.duration = 0.2
        navigationController?.navigationBar.layer.add(animation, forKey: nil)
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = backgroundImage
        tableHeaderIsHidden = !tableHeaderIsHidden
    }
    
    @objc private func shareMovie() {
        print(#function)
    }
    
    @objc private func favouriteTapped() {
        guard let movieDetail = movieDetail else { return }
        guard let headerView = self.tableView.tableHeaderView as? StretchyTableHeader else { return }
        presenter?.changeFavoriteStatus(movieDetail: movieDetail, movieImageData: headerView.imageView.image?.pngData())
    }
}

extension MovieViewController: MovieViewControllerProtocol {
    func dataFailure(text: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Ой-Ой", message: text) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func switchFavouritesIcon() {
        guard let addFavButton = navigationItem.rightBarButtonItems?[1] else { return }
        
        if presenter?.movieIsFavorite(id: movieId) == true {
            addFavButton.image = UIImage(systemName: "heart.fill")
        } else {
            addFavButton.image = UIImage(systemName: "heart")
        }
    }
    
    func configureData(movieDetail: MovieDetailResponse, movieCredits: MovieCreditsResponse) {
        self.movieDetail = movieDetail
        self.movieCredits = movieCredits
        configureHeaderView(with: movieDetail)
    }
    
    private func configureHeaderView(with movieDetail: MovieDetailResponse) {
        guard let headerView = self.tableView.tableHeaderView as? StretchyTableHeader else { return }
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(movieDetail.posterPath)"
        
        imageNetworkService.getImageFrom(imageUrlString) { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                headerView.imageView.image = image
            }
        }
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
}

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
        if movieDetail == nil && movieCredits == nil { return 0 }
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let movieDetail = movieDetail,
            let movieCredits = movieCredits
        else { fatalError() }
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: СinemaInfo.identifier, for: indexPath) as? СinemaInfo
            else { fatalError() }
            cell.configure(
                title: movieDetail.title,
                voteAverage: movieDetail.voteAverage,
                releaseDate: movieDetail.releaseDate,
                genres: movieDetail.genres
            )
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: СinemaOverview.identifier, for: indexPath) as? СinemaOverview
            else { fatalError() }
            cell.configure(overview: movieDetail.overview)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: СinemaVote.identifier, for: indexPath) as? СinemaVote
            else { fatalError() }
            cell.configure(vote: movieDetail.voteAverage, voteCount: movieDetail.voteCount)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastsCell.identifier, for: indexPath) as? CastsCell
            else { fatalError() }
            cell.casts = movieCredits.cast
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CrewsCell.identifier, for: indexPath) as? CrewsCell
            else { fatalError() }
            cell.crews = movieCredits.crew
            return cell
            
        default:
            fatalError()
        }
    }
}

extension MovieViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.tableView.tableHeaderView as? StretchyTableHeader else { return }
        headerView.scrollViewDidScroll(scrollView: scrollView)
        
        guard
            let movieDetail = movieDetail,
            let navigationController = navigationController as? StatusBarStyleNavigationController
        else { return }
        updateNavigationBarStyleIfNeeded(navigationController, movieDetail)
    }
    
    private func updateNavigationBarStyleIfNeeded(_ navigationController: StatusBarStyleNavigationController, _ movieDetail: MovieDetailResponse) {
        
        let navigationBarYPosition = navigationController.navigationBar.frame.maxY
        let indexPath = IndexPath(row: 0, section: 0)
        let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
        let cellYPosition = rectOfCellInSuperview.origin.y
        
        if cellYPosition <= navigationBarYPosition, tableHeaderIsHidden {
            self.title = movieDetail.title
            configureNavigationBarStyle(tintColor: .black, backgroundImage: nil)
            navigationController.statusBarEnterLightBackground()
        } else if cellYPosition > navigationBarYPosition, !tableHeaderIsHidden {
            self.title = nil
            configureNavigationBarStyle(tintColor: .white, backgroundImage: UIImage())
            navigationController.statusBarEnterDarkBackground()
        }
    }
}
