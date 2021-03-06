//
//  DetailsViewController.swift
//  Video Games
//
//  Created by ACS on 3.03.2021.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    var urlParameter = ""
    let network = APINetwork()
    
    @IBOutlet weak var favButton: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameReleaseDate: UILabel!
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var pointText: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.detailDelegate = self
        network.fetchGameDetail(slug: self.urlParameter)
    }
    
}

extension DetailsViewController: APIDetailNetworkDelegate {
    func didGetDetail(_ apiNetwork: APINetwork, videoGame: VideoGame) {
        DispatchQueue.main.async {
            
            self.gameName.text = videoGame.name
            self.gameReleaseDate.text = videoGame.released
            self.gameImage.kf.setImage(with: URL(string: videoGame.background_image))
            
            //Beautify description string
            var makeUpDescription = videoGame.description?.replacingOccurrences(of: "<p>", with: "  ")
            makeUpDescription = makeUpDescription?.replacingOccurrences(of: "<br />", with: "\n  ")
            makeUpDescription = makeUpDescription?.replacingOccurrences(of: "</p>", with: "\n  ")
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
