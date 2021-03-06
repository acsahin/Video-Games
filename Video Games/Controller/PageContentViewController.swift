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
    
    var videoGameImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: videoGameImage))
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = false
    }
}
