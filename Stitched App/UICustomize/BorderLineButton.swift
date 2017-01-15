//
//  BorderLineButton.swift
//  Stitched App
//
//  Created by Com on 15/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class BorderLineButton: UIButton {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor.white.cgColor
		self.layer.cornerRadius = 5.0
		self.clipsToBounds = true
	}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
