//
//  SavedArticleCell.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/10/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

// step 1 of custom delegate
protocol SavedArticleCellDelegate: AnyObject {
    // pasing the object (Cell and Article)
    func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article)
}

class SavedArticleCell: UICollectionViewCell {
    
    // step 2 of custom delegate
    weak var delegate: SavedArticleCellDelegate?
    
    // to keep track of current cell's article
    private var currentArticle: Article!
    
    // more button
    // article title
    // news image
    
    public lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.addTarget(self, action: #selector(moreButtonPressed(_:)), for: .touchUpInside)
      return button
    }()
    
    public lazy var articleTitle: UILabel = {
          let label = UILabel()
           label.numberOfLines = 2
           label.font = UIFont.preferredFont(forTextStyle: .title2)
           label.text = "The best headline ever"
        label.numberOfLines = 0
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
        setupMoreButtonConstraints()
        setupLabelConstraints()
    }
    
    @objc private func moreButtonPressed(_ sender: UIButton) {
        //print("button was pressed for article \(currentArticle.title)")
        
        // step 3 of custom delegate
        delegate?.didSelectMoreButton(self, article: currentArticle)
    }

    private func setupMoreButtonConstraints() {
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: topAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 44),
            moreButton.widthAnchor.constraint(equalTo: moreButton.heightAnchor)
        ])
    }
    private func setupLabelConstraints() {
        addSubview(articleTitle)
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            articleTitle.topAnchor.constraint(equalTo: moreButton.bottomAnchor),
            articleTitle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configureCell(for savedArticle: Article) {
        currentArticle = savedArticle // associating the cell with its article, if we dont do this, currebtArticle will be nil, and will crash
        articleTitle.text = savedArticle.title
    }
}
