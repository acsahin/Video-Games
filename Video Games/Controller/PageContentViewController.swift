//
//  PageContentViewController.swift
//  Video Games
//
//  Created by ACS on 3.03.2021.
//

import UIKit
import Kingfisher

class PageContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var videoGame = VideoGame(slug: "", name: "", released: "", background_image: "", rating: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: videoGame.background_image))
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = false
  
    }
}
