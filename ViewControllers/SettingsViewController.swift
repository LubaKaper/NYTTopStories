//
//  SettingsViewController.swift
//  NYTTopStories
//
//  Created by Liubov Kaper  on 2/6/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

struct UserKey {
    static let newsSection = "News Section"
}

class SettingsViewController: UIViewController {
    
    private let settingsView = SettingsView()
    
    // data for picker view
    private let sections = ["Arts", "Automobiles", "Books", "Business", "Fashion", "Food", "Health", "Insider", "Magazine", "Movies", "NYRegion", "Obituaries", "Opinion", "Politics", "RealeEstate", "Science", "Sports", "SundayReview", "Technology", "Theater", "T-Magazine", "Travel", "Upshot", "US", "World"].sorted() // from a-z
    
    override func loadView() {
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        
        // setup pickerview
        settingsView.pickerView.dataSource = self
        settingsView.pickerView.delegate = self
    }
    
}
extension SettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sections.count
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row] // accessing each indidual string in the sections array
    }
    
    // here we setting up UserDefaults to capture section chosen to update API call
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // store the current selected news section in userDefaults
        //print(sections[row])
        let sectionName = sections[row]
        UserDefaults.standard.set(sectionName, forKey: UserKey.newsSection)
    }
}
