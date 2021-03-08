//
//  DetailsViewController.swift
//  Video Games
//
//  Created by ACS on 3.03.2021.
//

import UIKit
import Kingfisher
import CoreData

class DetailsViewController: UIViewController {
    
    //Slug
    var urlParameter = ""
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let network = APINetwork()
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameReleaseDate: UILabel!
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var pointText: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var favButton: UIButton!
    
    private var imageUrlString = ""
    private var rating: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.detailDelegate = self
        network.fetchGameDetail(slug: self.urlParameter)
    }
    
    @IBAction func addFavourites(_ sender: UIButton) {
        
        //Delete Block
        if sender.backgroundImage(for: .normal) == UIImage(systemName: "hand.thumbsup.fill") {
            
            sender.setBackgroundImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            sender.tintColor = .white
            
            LocalDBNetwork.shared.deleteVideoGame(urlParameter)
            
            //Save Block
        }else {
            sender.setBackgroundImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            sender.tintColor = .systemBlue
            
            //If it doesn't exist already
            //save it
            let newVG = LocalVideoGame(context: context)
            newVG.name = gameName.text
            newVG.released = gameReleaseDate.text
            newVG.slug = urlParameter
            newVG.background_image = imageUrlString
            newVG.rating = rating
            
            LocalDBNetwork.shared.saveVideoGame()
        }
    }
}

extension DetailsViewController: APIDetailNetworkDelegate {
    
    func didGetDetail(_ apiNetwork: APINetwork, videoGame: VideoGame) {

        
        DispatchQueue.main.async {
            self.favButton.isHidden = false
            if LocalDBNetwork.shared.isVideoGameExist(self.urlParameter)?.count == 0 {
                self.favButton.setBackgroundImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
                self.favButton.tintColor = .white
            }else {
                self.favButton.setBackgroundImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                self.favButton.tintColor = .systemBlue
            }
            
            self.imageUrlString = videoGame.background_image
            self.rating = videoGame.rating
            self.gameName.text = videoGame.name
            self.gameReleaseDate.text = videoGame.released
            self.gameImage.kf.setImage(with: URL(string: videoGame.background_image))
            
            //Beautify description string
            var makeUpDescription = videoGame.description?.replacingOccurrences(of: "<p>", with: "")
            makeUpDescription = makeUpDescription?.replacingOccurrences(of: "<br />", with: "\n")
            makeUpDescription = makeUpDescription?.replacingOccurrences(of: "</p>", with: "\n")
            self.descriptionText.text = makeUpDescription
            
            //Metacritic point view
            if let point = videoGame.metacritic {
                self.pointText.text = String(point)
                if point >= 75 {
                    self.pointView.backgroundColor = .green
                }else if point >= 50, point < 75 {
                    self.pointView.backgroundColor = .orange
                }else {
                    self.pointView.backgroundColor = .red
                }
            }
        }
        
    }
}
