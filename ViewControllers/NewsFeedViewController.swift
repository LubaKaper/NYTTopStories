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
    
    // properties
    private let newsFeedView = NewsFeedView()
    
    // step 2: seeting up data persistance and delegate:
    // since we need an instance passed to the article detail controller we declare a dataPersistance here
    // if don't have a d3fault value, make an initializer, hree we added initializer and got rid of optional(!)
    private var dataPersistance: DataPersistence<Article>
    
    
    
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
    
    // initializers
    init(_ dataPersistance: DataPersistence<Article>) {
        self.dataPersistance = dataPersistance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coser:) has  not been implemented")
    }
    
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
       // fetchStories()
       
        newsFeedView.searchBar.delegate = self
        
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
            } else {
                queriAPI(for: sectionName)
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
            let articleDetailVC = ArticleDetailController(dataPersistance, article: article)
            
            // tODO: after assesment we will be using initializers as dependancy injection mechsnism
           // articleDetailVC.article = article
            
            // step 3 seeting up data persistance and delegate:
            // paSSING PERSISTANCE to detailVC
           // articleDetailVC.dataPersistance = dataPersistance
            navigationController?.pushViewController(articleDetailVC, animated: true)
        }
        // dismisses scrollview when user starts scrolling
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if newsFeedView.searchBar.isFirstResponder {
                newsFeedView.searchBar.resignFirstResponder()
            }
        }
}

extension NewsFeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            // if text is Empty reload all articles
            fetchStories()
            return
        }
        // filter articles based on search text
        newsArticles = newsArticles.filter { $0.title.lowercased().contains(searchText.lowercased())}
    }
}
