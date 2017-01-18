//
//  HomeViewModel.swift
//  Stitched App
//
//  Created by Com on 17/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit


struct PostedJob {
	var id: String?
	var title: String?
	var description: String?
	var category: JobCategory
	var deliveryTime: JobDeliverTime
	var price: String?
	var attachType: JobAttachType
	var attachURL: String?
	var clientID: String?
	
	init() {
		self.category = .one
		self.deliveryTime = .one
		self.attachType = .nothing
	}
}


class HomeViewModel: NSObject {
	var myJobs = [PostedJob]()
	
	var loadCompleteHandler: (() -> ())?
	
	func loadMyPostingJobs() {
		//Reference.FBRef.allJobs.observeSingleEvent(of: .value, with: { (snap) in
		Reference.FBRef.allJobs.observe(.value, with: { (snap) in
			let allItems = snap.value as! [String: AnyObject]!
			
			self.myJobs.removeAll()
			for key in (allItems?.keys)! {
				let each = allItems?[key] as! [String: AnyObject]!
				
				if currentUser.id == each?["owner"] as! String? {
					var aJob = PostedJob()
					aJob.id = key
					aJob.title = each?["title"] as! String?
					aJob.description = each?["description"] as! String?
					aJob.category = JobCategory(s: (each?["category"] as! String?)!)
					aJob.deliveryTime = JobDeliverTime(s: (each?["deliverTime"] as! String?)!)
					aJob.price = each?["price"] as! String?
					aJob.attachType = JobAttachType(s: (each?["attachType"] as! String?)!)
					aJob.attachURL = each?["attachURL"] as! String?
					aJob.clientID = each?["owner"] as! String?
					self.myJobs.append(aJob)
				}
			}
			
			self.loadCompleteHandler!()
		})
	}
}
