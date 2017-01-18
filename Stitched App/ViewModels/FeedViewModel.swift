//
//  FeedViewModel.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class FeedViewModel: NSObject {
	var allJobs = [PostedJob]()
	
	var loadCompleteHandler: (() -> ())?
	
	func loadJobs() {
		//Reference.FBRef.allJobs.observeSingleEvent(of: .value, with: { (snap) in
		Reference.FBRef.allJobs.observe(.value, with: { (snap) in
			let allItems = snap.value as! [String: AnyObject]!
			
			self.allJobs.removeAll()
			for key in (allItems?.keys)! {
				let each = allItems?[key] as! [String: AnyObject]!
				
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
				self.allJobs.append(aJob)
			}
			
			self.loadCompleteHandler!()
		})
	}
	
}
