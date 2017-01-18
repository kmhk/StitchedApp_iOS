//
//  HomeColletionHeaderCell.swift
//  Stitched App
//
//  Created by Com on 17/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import Nuke

class HomeColletionHeaderCell: UICollectionReusableView {
	static var id = "HomeColletionHeaderCell"
	
	@IBOutlet weak var imgViewAvatar: UIImageView!
	@IBOutlet weak var imgViewRanking: UIImageView!
	@IBOutlet weak var lblName: UILabel!
	
	@IBOutlet weak var lblFollower: UILabel!
	@IBOutlet weak var lblNetwork: UILabel!
	
	override func layoutSubviews() {
		imgViewAvatar.layer.cornerRadius = imgViewAvatar.frame.size.width / 2
		imgViewAvatar.clipsToBounds = true
		imgViewAvatar.layer.borderWidth = 1
	}
	
	func setup(with model: HomeViewModel) {
		var req = Request(url: URL(string: (currentUser.avatar)!)!)
		req.memoryCacheOptions.readAllowed = false
		req.memoryCacheOptions.writeAllowed = false
		Nuke.loadImage(with: req, into: imgViewAvatar)
		
		imgViewRanking.image = UIImage(named: "rank" + currentUser.ranking)
		lblName.text = currentUser.name
		lblFollower.text = "\(currentUser.follower)"
		lblNetwork.text = "\(currentUser.network)"
	}
}
