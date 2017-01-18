//
//  DetailJobBidCell.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class DetailJobBidCell: UITableViewCell {
	
	static var id = "DetailJobBidCell"
	
	@IBOutlet weak var txtBid: UITextView!
	@IBOutlet weak var btnBid: UIButton!
	@IBOutlet weak var lblProposal: UILabel!
	
	var bidHandler: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func bidBtnTap(_ sender: Any) {
		guard bidHandler != nil else { return }
		
		bidHandler!()
	}

	func setup(withJob job: PostedJob, status: BidStatus) {
		txtBid.text = ""
		txtBid.placeholder = "Please type your proposal here"
		txtBid.becomeFirstResponder()
		
		if status == .bidding {
			txtBid.isEditable = true
			btnBid.isHidden = false
			lblProposal.isHidden = true
			
		} else {
			txtBid.isEditable = false
			btnBid.isHidden = true
			lblProposal.isHidden = false
			
			var bidInfo = job.bids?[currentUser.id] as! [String: AnyObject]
			txtBid.text = bidInfo["proposal"] as! String!
		}
	}
}
