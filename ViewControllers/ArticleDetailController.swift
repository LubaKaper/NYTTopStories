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
    
    public var article: Article?
    
    public var dataPersistance: DataPersistence<Article>!

    
    private let detailView = ArticleDetailView()
    
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
        guard let article = article else {
            fatalError("did not load an article")
        }
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
        guard let article = article else {return}
        do {
            // saves to documents directory after save button pressed
        try dataPersistance.createItem(article)
        } catch {
            print("error saving article: \(error)")
        }
        
    }
}
