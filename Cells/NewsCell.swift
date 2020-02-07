//
//  NewsCell.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/7/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import ImageKit

class NewsCell: UICollectionViewCell {
    
    // image view of article
    public lazy var newsImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .yellow// for testing
        return iv
    }()
    
    // title of article
    
    public lazy var articleTitleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Article Title"
        return label
    }()
    
    // abstract of article
    
    public lazy var articleHeadlineLabel: UILabel = {
          let label = UILabel()
           label.numberOfLines = 3
           label.font = UIFont.preferredFont(forTextStyle: .subheadline)
           label.text = "Abstract headline"
           return label
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
       setupNewsImageViewConstraints()
        setupArticleTitleConstraints()
        setupAbstractHeadlineConstraints()
    }

    private func setupNewsImageViewConstraints() {
        addSubview(newsImageView)
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            newsImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.30),
            newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor)
        ])
    }
    
    private func setupArticleTitleConstraints() {
        addSubview(articleTitleLabel)
        articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articleTitleLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            articleTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 8),
            articleTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func setupAbstractHeadlineConstraints() {
        addSubview(articleHeadlineLabel)
        articleHeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articleHeadlineLabel.leadingAnchor.constraint(equalTo: articleTitleLabel.leadingAnchor),
            articleHeadlineLabel.trailingAnchor.constraint(equalTo: articleTitleLabel.trailingAnchor),
            articleHeadlineLabel.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 8)
        ])
    }
    
    public func configureCell(with article: Article) {
        
        articleTitleLabel.text = article.title
        articleHeadlineLabel.text = article.abstract
        
        newsImageView.getImage(with: article.getArticleImageURL(for: .thumbLarge)) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(systemName: "exclamationmark - octagon")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.newsImageView.image = image
                }
                
            }
        }
        
    // image formats: superJumbo 2048 x 1365, thiumbnail: 150 x 150
    }
}
