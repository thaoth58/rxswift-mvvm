//
//  CategoryCell.swift
//  MyYoutube
//
//  Created by Thao Truong on 4/24/18.
//  Copyright © 2018 GEM. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    static let Identifier = "CategoryCell"
    var video: Video? {
        didSet {
            guard let video = video else { return }
            bindingData(video: video)
        }
    }
    
    func bindingData(video: Video) {
        titleLabel.text = video.title
        descLabel.text = video.desc
        if let thumbnailUrl = video.thumbnailUrl {
            thumbnailImage.kf.setImage(with: URL(string: thumbnailUrl))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
