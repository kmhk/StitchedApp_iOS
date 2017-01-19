//
//  CommunityTableViewCell.swift
//  Stitched App
//
//  Created by Com on 19/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import Nuke


class CommunityTableViewCell: UITableViewCell {
	
	static var id = "CommunityTableViewCell"
	
	@IBOutlet weak var imgAvatar: UIImageView!
	@IBOutlet weak var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setup(with user: User) {
		lblName.text = user.name
		
		imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2
		imgAvatar.layer.borderWidth = 1.0
		imgAvatar.layer.borderColor = UIColor.black.cgColor
		imgAvatar.clipsToBounds = true
		
		let req = Request(url: URL(string: user.avatar)!)
		Nuke.loadImage(with: req, into: imgAvatar)
	}
}
