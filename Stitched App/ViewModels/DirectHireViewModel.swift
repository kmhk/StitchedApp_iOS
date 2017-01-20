//
//  DirectHireViewModel.swift
//  Stitched App
//
//  Created by Com on 20/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class DirectHireViewModel: NSObject {
	var users = [User]()
	var category: JobCategory = .one
	
	var completeHandler: (() -> ())?
	
	func getAllUsers() {
		Reference.FBRef.allUsers.observe(.value, with: { (snap) in
			let allItems = snap.value as! [String: AnyObject]!
			
			self.users.removeAll()
			for key in (allItems?.keys)! {
				var user = User()
				
				let userData = allItems?[key] as! [String: Any]!
				user.id = key
				user.createUser(with: userData)
				if user.role == "vendor" {
					self.users.append(user)
				}
			}
			
			self.completeHandler?()
		})
	}
}
