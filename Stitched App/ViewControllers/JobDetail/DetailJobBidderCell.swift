//
//  DetailJobBidderCell.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import Nuke

class DetailJobBidderCell: UITableViewCell {
	
	static var id = "DetailJobBidderCell"

	@IBOutlet weak var imgAvatar: UIImageView!
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var lblProposal: UILabel!
	@IBOutlet weak var btnHire: UIButton!
	@IBOutlet weak var btnChat: UIButton!
	
	var chatHandler: (() -> ())?
	var hireHandler: (() -> ())?
	
	var user: User?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func btnHireTap(_ sender: Any) {
		guard hireHandler != nil else {
			return
		}
		
		hireHandler?()
	}
	
	
	@IBAction func btnChatTap(_ sender: Any) {
		guard chatHandler != nil else {
			return
		}
		
		chatHandler?()
	}
	
	
	func setup(withUser usr: User) {
		self.user = usr
		
		self.lblName.text = self.user?.name
		self.lblProposal.text = "Service Provides...."
		
		self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width / 2
		self.imgAvatar.layer.borderWidth = 1.0
		self.imgAvatar.layer.borderColor = UIColor.black.cgColor
		self.imgAvatar.clipsToBounds = true
		
		var req = Request(url: URL(string: (self.user?.avatar)!)!)
		req.memoryCacheOptions.readAllowed = false
		req.memoryCacheOptions.writeAllowed = false
		Nuke.loadImage(with: req, into: self.imgAvatar)
	}
	
	
	func setup(withJob job: PostedJob, index: Int) {
		guard (job.bids?.count)! > index else {
			return
		}
		
		var i = 0
		for ID in (job.bids?.keys)! {
			if i == index {
				var bidInfo = job.bids?[ID] as! [String: AnyObject]
				
				lblProposal.text = bidInfo["proposal"] as! String?
				User.getUser(fromID: ID, complete: { (usr) in
					self.user = usr
					
					self.lblName.text = self.user?.name
					
					self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.width / 2
					self.imgAvatar.layer.borderWidth = 1.0
					self.imgAvatar.layer.borderColor = UIColor.black.cgColor
					self.imgAvatar.clipsToBounds = true
					
					var req = Request(url: URL(string: (self.user?.avatar)!)!)
					req.memoryCacheOptions.readAllowed = false
					req.memoryCacheOptions.writeAllowed = false
					Nuke.loadImage(with: req, into: self.imgAvatar)
				})
				
				break
			}
			
			i = i + 1
		}
	}
	
}
