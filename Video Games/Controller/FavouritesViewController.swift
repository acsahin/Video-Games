//
//  FavouritesViewController.swift
//  Video Games
//
//  Created by ACS on 3.03.2021.
//

import UIKit
import Kingfisher
import CoreData

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var localData = [LocalVideoGame]()
    private var chosenVideoGameSlug: String = ""
    
    //private var localDB = LocalDBNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        localDB.delegate = self
//        localDB.loadVideoGames()
        LocalDBNetwork.shared.delegate = self
        LocalDBNetwork.shared.loadVideoGames()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Init collectionView with custom cell
        self.collectionView.register(UINib.init(nibName: "VideoGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "videoGameCell")
        
    }
}


extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoGameCell", for: indexPath) as! VideoGameCollectionViewCell
        
        cell.label.text = localData[indexPath.row].name
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: URL(string: localData[indexPath.row].background_image!))
        cell.ratingLabel.text = String(localData[indexPath.row].rating)
        cell.dateLabel.text = localData[indexPath.row].released
        
        cell.layer.shadowColor = UIColor.darkGray.cgColor

        return cell
    }
    
    //On tap collectionView cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenVideoGameSlug = localData[indexPath.row].slug!
        self.performSegue(withIdentifier: "goToDetailView", sender: self)
    }
    //Pass data with segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailView" {
            if let detailVC = segue.destination as? DetailsViewController {
                detailVC.urlParameter = chosenVideoGameSlug
            }
        }
    }
}

extension FavouritesViewController: LocalDBDelegate {
    func didUpdateVideoGames(_ localDBNetwork: LocalDBNetwork, videoGames: [LocalVideoGame]) {
        DispatchQueue.main.async {
            self.localData.removeAll()
            self.localData = videoGames
            self.collectionView.layoutIfNeeded()
            self.collectionView.reloadData()
        }
    }
}
