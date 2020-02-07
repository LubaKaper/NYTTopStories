//
//  ArticleDetailView.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/7/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

class ArticleDetailView: UIView {
    
    // image view
    public lazy var newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .yellow// for testing
        return iv
    }()
    // abstarct headline
    public lazy var abstarctHeadLinelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.text = "Abstract headline"
        return label
    }()
    // byline
    
    // date
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupNewsImageViewConstarints()
        setupAbstractHeadlineConstraint()
    }

    private func setupNewsImageViewConstarints() {
        addSubview(newsImageView)
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.40)
        ])
    }
    private func setupAbstractHeadlineConstraint() {
        addSubview(abstarctHeadLinelabel)
        abstarctHeadLinelabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            abstarctHeadLinelabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 8),
            abstarctHeadLinelabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            abstarctHeadLinelabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
            
        ])
    }
}
