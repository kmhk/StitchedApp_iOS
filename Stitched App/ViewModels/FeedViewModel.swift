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
		Reference.FBRef.loadPostedJob(Of: nil, forUser: nil) { (jobs) in
			self.allJobs = jobs
			self.loadCompleteHandler!()
		}
	}
	
}
