//
//  PostJobTitleCell.swift
//  Stitched App
//
//  Created by Com on 17/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class PostJobTitleCell: UITableViewCell {
	
	static var id = "PostJobTitleCell"
	
	@IBOutlet weak var txtTitle: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
