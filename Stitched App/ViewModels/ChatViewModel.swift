//
//  ChatViewModel.swift
//  Stitched App
//
//  Created by Com on 19/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

enum ChatPeople: String {
	case me = "me"
	case opponent = "opponent"
	
	static let values = [me, opponent]
	
	init(with s: String) {
		for key in ChatPeople.values {
			if s == key.rawValue {
				self = key
				return
			}
		}
		
		self = .me
	}
}

struct ChatEntry {
	var who: ChatPeople
	var message: String
}


class ChatViewModel: NSObject {
	var chatRoomID: String?
	var opponent: User?
	var history = [ChatEntry]()
	var received: Int = 0
	
	var showChat: (() -> ())?
	
	
	func retreiveChatHistory() {
		Reference.FBRef.allChats.child(chatRoomID!).observe(.value, with: { (snap) in
			guard (snap.value as AnyObject).classForCoder != NSNull.classForCoder() else { return }
			
			let allItems = snap.value as! [String: AnyObject]!
			
			var chats = [ChatEntry]()
			for i in 1...(allItems?.keys.count)! {
				let key = "msg" + "\(i)"
				var item = allItems?[key] as! [String: AnyObject]!
				
				let op = item?["who"] as! String
				let msg = item?["message"] as! String
				let who = (op == currentUser.id ? "me" : "opponent")
				let entry = ChatEntry(who: ChatPeople(rawValue: who)!, message: msg)
				
				chats.append(entry)
			}
			
			self.history = chats
			
			self.showChat?()
		})
	}
	
	
	func loadChatHistory(from chatRoom: String) {
		chatRoomID = chatRoom
		
		let keys = chatRoomID?.components(separatedBy: "+")
		for key in keys! {
			if key != currentUser.id {
				let opID = key
				User.getUser(fromID: opID) { (user) in
					self.opponent = user
					self.retreiveChatHistory()
				}
				
				break
			}
		}
	}
	
	
	func sendMyMsg(msg: String) {
		let entry = ["who": currentUser.id,
		             "message": msg]
		let key = "msg" + String(history.count+1)
		let record = [key: entry]
		
		Reference.FBRef.allChats.child(chatRoomID!).updateChildValues(record)
	}
	
}
