//
//  PageContentViewController.swift
//  Video Games
//
//  Created by ACS on 3.03.2021.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var labelPageNumber: UILabel!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelPageNumber.text = "\(index + 1)"
        
        let r = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let g = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let b = CGFloat(arc4random()) / CGFloat(UInt32.max)
        self.view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)

    }

}
