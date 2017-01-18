//
//  HomeCollectionPostCell.swift
//  Stitched App
//
//  Created by Com on 17/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class HomeCollectionPostCell: UICollectionViewCell {
    static var id = "HomeCollectionPostCell"
	
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var imgAttach: UIImageView!
	@IBOutlet weak var lblDescription: UILabel!
	
	@IBOutlet weak var lblPrice: UILabel!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		layer.cornerRadius = 5.0
		layer.borderWidth = 1.0
		layer.borderColor = Utils.borderColor().cgColor
		clipsToBounds = true
	}
	
	func setup(with job: PostedJob) {
		lblTitle.text = job.title
		lblPrice.text = "Price: $" + job.price!
		lblDescription.text = job.description
		
		if job.attachType == .nothing {
			imgAttach.image = nil
		} else if job.attachType == .image {
			imgAttach.image = UIImage(named: "attachedImage")
		} else {
			imgAttach.image = UIImage(named: "attachedVideo")
		}
	}
}
