//
//  DetailJobInfoCell.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class DetailJobInfoCell: UITableViewCell {
	
	static var id = "DetailJobInfoCell"

	@IBOutlet weak var lblCategory: UILabel!
	@IBOutlet weak var lblDelivery: UILabel!
	@IBOutlet weak var lblPrice: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
