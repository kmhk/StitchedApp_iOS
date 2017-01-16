//
//  ProfileTextField.swift
//  Stitched App
//
//  Created by Com on 15/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class ProfileTextField: UITextField, UITextFieldDelegate {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		let text = NSAttributedString(string: self.placeholder!,
		                              attributes: [NSForegroundColorAttributeName: UIColor.gray,
		                                           NSFontAttributeName: self.font!])
		self.attributedPlaceholder = text
		
		self.delegate = self
	}

	// MARK: - UITextFieldDelegate
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.resignFirstResponder()
		
		return true
	}
}
