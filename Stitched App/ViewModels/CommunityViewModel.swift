//
//  CommunityViewModel.swift
//  Stitched App
//
//  Created by Com on 19/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class CommunityViewModel: NSObject {
	var roomIDs = [String]()
	var users = [User]()
	
	var completeHandler: (() -> ())?
	
	var newMessageReceivedHandler: (() -> ())?
	
	func loadAllChatRoom() {
		Reference.FBRef.allChats.observe(.value, with: { (snap) in
			guard (snap.value as AnyObject).classForCoder != NSNull.classForCoder() else { return }
			
			let allItems = snap.value as! [String: AnyObject]!
			
			self.newMessageReceivedHandler?()
			
			self.roomIDs.removeAll()
			self.users.removeAll()
			for key in (allItems?.keys)! {
				if self.isMyRoom(with: key) == true {
					let opID = self.getOpponentID(from: key)
					User.getUser(fromID: opID, complete: { (user) in
						self.users.append(user!)
						self.roomIDs.append(key)
						
						self.completeHandler?()
					})
				}
			}
		})
	}
	
	func isMyRoom(with ID: String) -> Bool {
		let keys = ID.components(separatedBy: "+")
		for key in keys {
			if key == currentUser.id {
				return true
			}
		}
		
		return false
	}
	
	func getOpponentID(from ID: String) -> String {
		let keys = ID.components(separatedBy: "+")
		for key in keys {
			if key != currentUser.id {
				return key
			}
		}
		
		return ""
	}
}
