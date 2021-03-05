//
//  VideoGameCollectionViewCell.swift
//  Video Games
//
//  Created by ACS on 5.03.2021.
//

import UIKit

class VideoGameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
