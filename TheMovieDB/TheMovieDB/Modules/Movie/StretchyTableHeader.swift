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
    
    private let infoLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 18, weight: .thin))
        $0.textColor = .init(white: 0.1, alpha: 1)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let gradientView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    private let gradientLayer: CAGradientLayer = {
        $0.colors = [UIColor.clear.cgColor, UIColor.init(white: 1, alpha: 0.9).cgColor]
        $0.startPoint = CGPoint(x: 0, y: 0)
        $0.endPoint = CGPoint(x: 0, y: 1)
        return $0
    }(CAGradientLayer())
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setViewConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        addSubview(containerView)
        addSubview(gradientView)
        addSubview(infoLabel)
        containerView.addSubview(imageView)
    }
    
    private func setViewConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2)
        ])
        
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
    
    func configure(with text: String) {
        infoLabel.text = text
    }
}
