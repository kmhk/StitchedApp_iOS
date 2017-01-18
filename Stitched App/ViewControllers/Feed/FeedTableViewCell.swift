//
//  FeedTableViewCell.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
	
	static var id = "FeedTableViewCell"

	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblDescription: UILabel!
	@IBOutlet weak var lblBudget: UILabel!
	@IBOutlet weak var deliverTime: UILabel!
	
	@IBOutlet weak var lblBidMark: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setup(with job: PostedJob) {
		lblTitle.text = job.title
		lblDescription.text = job.description
		lblBudget.text = "Budget: $" + job.price!
		deliverTime.text = job.deliveryTime.rawValue
		
		if job.bids?[currentUser.id] == nil {
			lblBidMark.isHidden = true
		} else {
			lblBidMark.isHidden = false
		}
	}
}
