//
//  JobDetailViewModel.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class JobDetailViewModel: NSObject {
	var job: PostedJob?
	
	var errorHandler: ((Error) -> ())?
	var completeBidHandler: (() -> ())?
	
	func bidToJob(withPropsal proposal: String) {
		guard proposal.lengthOfBytes(using: .utf8) > 0 else {
			print("nothing propsoal string!")
			return
		}
		
		Reference.FBRef.bidTo(Job: job!, user: currentUser, propsal: proposal) { (ref, error) in
			guard error == nil else { self.errorHandler?(error!); return }
			
			self.completeBidHandler?()
		}
	}
}
