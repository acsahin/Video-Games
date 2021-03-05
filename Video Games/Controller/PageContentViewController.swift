//
//  PageContentViewController.swift
//  Video Games
//
//  Created by ACS on 3.03.2021.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: String(index))

        self.view.layer.cornerRadius = 20
        self.view.layer.masksToBounds = true
  
    }
}
