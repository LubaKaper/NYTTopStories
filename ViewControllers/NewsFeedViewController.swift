//
//  NewsFeedViewController.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/6/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    private let newsFeedView = NewsFeedView()
    
    override func loadView() {
        view = newsFeedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground // white when dark mode is off, black when dark mode is on
        newsFeedView.collectionView.delegate = self
        newsFeedView.collectionView.dataSource = self
        
        // register cell
        newsFeedView.collectionView.register(NewsCell.self, forCellWithReuseIdentifier: "articleCell")
    }
    
    private func fetchStories(for section: String = "Technologies") {
        NYTTopStoriesAPIClient.fetchTopStories(for: section) { (result) in
            switch result {
            case .failure(let appError):
                print("error fetching stories : \(appError)")
            case .success(let articles):
                print("found: \(articles.count)")
                
            }
        }
    }
    


}
extension NewsFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? NewsCell else {
            fatalError("could not deque NewsCell")
            
        }
        cell.backgroundColor = .white
        return cell
    }
    
    
}
    extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    // return item size
    // itemHeight: 30% of height of devoice
    // width: 100% of width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.30
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
