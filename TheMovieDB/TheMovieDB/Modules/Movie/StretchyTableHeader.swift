//
//  StretchyTableHeader.swift
//  TheMovieDB
//
//  Created by user on 01.11.2021.
//

import UIKit

final class StretchyTableHeader: UIView {
    
    let imageView: UIImageView = {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private let titileLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 28, weight: .semibold))
        $0.textColor =  .white
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "8.0"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViews() {
        addSubview(containerView)
//        addSubview(titileLabel)
        containerView.addSubview(imageView)
    }
    
    func setViewConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            titileLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titileLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            titileLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
//        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
            containerViewHeight.constant = scrollView.contentInset.top
            let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
            containerView.clipsToBounds = offsetY <= 0
            imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
            imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
        }
}
