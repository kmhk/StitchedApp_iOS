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
	var bids: [String: AnyObject]?
	
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
		Reference.FBRef.loadPostedJob(Of: currentUser, forUser: nil) { (jobs) in
			self.myJobs = jobs
			self.loadCompleteHandler!()
		}
	}
	
	func loadMyBiddedJobs() {
		Reference.FBRef.loadPostedJob(Of: nil, forUser: currentUser) { (jobs) in
			self.myJobs = jobs
			self.loadCompleteHandler!()
		}
	}
}
