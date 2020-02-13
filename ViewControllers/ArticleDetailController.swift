//
//  ArticleDetailController.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/7/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import ImageKit
import DataPersistence

class ArticleDetailController: UIViewController {
    
    
    // properties
    private var article: Article
    
    private var dataPersistance: DataPersistence<Article>

    
    private let detailView = ArticleDetailView()
    
    // initializer
    init(_ dataPersistance: DataPersistence<Article>, article: Article) {
        self.dataPersistance = dataPersistance
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coser:) has  not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        // adding UIBarbuttonItem to the right side of navigation bar's title, to save to saved articles
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
    }
    
    // TODO: refactot and setup in DetailView
    private func updateUI() {
        
        navigationItem.title = article.title
        detailView.abstarctHeadLinelabel.text = article.abstract
        detailView.newsImageView.getImage(with: article.getArticleImageURL(for: .superJumbo)) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.detailView.newsImageView.image = UIImage(systemName: "exclamationmark - octagon")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.detailView.newsImageView.image = image
                }
            }
        }
    }
   
    @objc func saveArticleButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            // saves to documents directory after save button pressed
        try dataPersistance.createItem(article)
            print("article saved")
        } catch {
            print("error saving article: \(error)")
        }
        
    }
}
