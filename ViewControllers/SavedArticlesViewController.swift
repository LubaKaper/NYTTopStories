//
//  SavedArticlesViewController.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/6/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import DataPersistence

class SavedArticlesViewController: UIViewController {
    
    private let savedArticleView = SavedArticleView()
    
    // step 4 seeting up data persistance and delegate
    public var dataPersistance: DataPersistence<Article>!
    
    // TODO: create a SavedArticleView
    // TODO: add a collection view to SavedArticle View
    // TODO: create ans array of savedArticles = [Arlete methodticle]
    // TODO: reload collection view in didSet of the savedArticles array

    private var savedArticles = [Article]() {
        didSet {
           // print("there are \(savedArticles.count) articles")
            savedArticleView.collectionView.reloadData()
            if savedArticles.isEmpty {
                
                // setup background view, in case there are no saved articles
                savedArticleView.collectionView.backgroundView = EmptyView(title: "Saved Articles", messege: "There are currently no saved articles. Start browsing by tapping on the New icon")
            } else {
                savedArticleView.collectionView.backgroundView = nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        fetchSavedArticles()
        
        savedArticleView.collectionView.register(SavedArticleCell.self, forCellWithReuseIdentifier: "savedArticleCell")
        
        // setup collectionview
        savedArticleView.collectionView.dataSource = self
        savedArticleView.collectionView.delegate = self
    }
    
    override func loadView() {
        view = savedArticleView
    }

    private func fetchSavedArticles() {
        do {
            savedArticles = try dataPersistance.loadItems()
        } catch {
            print("error saving articles \(error)")
        }
    }
}

extension SavedArticlesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedArticleCell", for: indexPath) as? SavedArticleCell else {
            fatalError("could not downcast to SavedArticleCell")
        }
        cell.backgroundColor = .systemBackground
        let savedArticle = savedArticles[indexPath.row]
        cell.configureCell(for: savedArticle)
        
        // step 4 of custom delegate
        cell.delegate = self
        return cell
    }
    
    
}

extension SavedArticlesViewController: UICollectionViewDelegateFlowLayout {
    // setup width and height of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let spacingBetweenItems: CGFloat = 10
        let numberOfItems: CGFloat = 2
        let itemHeight: CGFloat = maxSize.height * 0.30
        let totalSpacing: CGFloat = (2 * spacingBetweenItems) + (numberOfItems - 1) * spacingBetweenItems
        let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    // spacing around collection view(not between the cells)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}


// step 5 seeting up data persistance and delegate:
// conforming to DataPersistanceDelegate
extension SavedArticlesViewController: DataPersistenceDelegate {
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
       // print("item was saved")
        fetchSavedArticles()
       
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        //print("item was deleted")
        // this updates the collection view after item was deleted in a directory
        fetchSavedArticles()
    }
}

// step 5 of custom delegate
extension SavedArticlesViewController: SavedArticleCellDelegate {
    func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article) {
        print("didSelectMoreButton: \(article.title)")
        
        // create action sheet: cancel, delete, share(later)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertAction in
            // write a delete helper function
            self.deleteArticle(article)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    private func deleteArticle(_ article: Article) {
        guard let index = savedArticles.firstIndex(of: article) else {
            return
        }
        do {
            // deletes from documents directory
            try dataPersistance.deleteItem(at: index)
        } catch {
            print("error deleting article \(error)")
            
        }
    }
}


