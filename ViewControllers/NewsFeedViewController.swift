//
//  NewsFeedViewController.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/6/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import DataPersistence

class NewsFeedViewController: UIViewController {
    
    private let newsFeedView = NewsFeedView()
    
    // step 2: seeting up data persistance and delegate:
    // since we need an instanve passed to the article detail controller we declare a dataPersistance here
    public var dataPersistance: DataPersistence<Article>!
    
    // data for our collection view
    private var newsArticles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.newsFeedView.collectionView.reloadData()
                self.navigationItem.title = (self.newsArticles.first?.section.capitalized ?? "") + " News"
            }
        }
    }
    
    private var sectionName = "Technologie"
    
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
        fetchStories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchStories()
    }
    
    private func fetchStories(for section: String = "Technologies") {
        
        // retrieve section name from UserDefaults
        if let sectionName = UserDefaults.standard.object(forKey: UserKey.newsSection) as? String {
            if sectionName != self.sectionName {
                // we are looking at a new section
                // make a new query
                queriAPI(for: sectionName)
                self.sectionName = sectionName
            } 
        } else {
           // use default section name
            queriAPI(for: sectionName)
        }
        
    }
    private func queriAPI(for section: String) {
        NYTTopStoriesAPIClient.fetchTopStories(for: section) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print("error fetching stories : \(appError)")
            case .success(let articles):
                self?.newsArticles = articles
                
            }
        }
    }
    


}
extension NewsFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArticles.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? NewsCell else {
            fatalError("could not deque NewsCell")
            
        }
        let article = newsArticles[indexPath.row]
        cell.configureCell(with: article)
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
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let article = newsArticles[indexPath.row]
            let articleDetailVC = ArticleDetailController()
            
            // tODO: after assesment we will be using initializers as dependancy injection mechsnism
            articleDetailVC.article = article
            
            // step 3 seeting up data persistance and delegate:
            // paSSING PERSISTANCE to detailVC
            articleDetailVC.dataPersistance = dataPersistance
            navigationController?.pushViewController(articleDetailVC, animated: true)
        }
}
