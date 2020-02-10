//
//  SavedArticleView.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/10/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

class SavedArticleView: UIView {
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGroupedBackground
        return cv
    }()
    
   

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
      setUpCollectionViewConstraints()
    }

    
    private func setUpCollectionViewConstraints() {
           addSubview(collectionView)
           collectionView.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
               collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
               collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
               collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
           ])
       }

}
