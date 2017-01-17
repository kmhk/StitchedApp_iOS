//
//  PostViewModel.swift
//  Stitched App
//
//  Created by Com on 17/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit


enum JobDeliverTime: String {
	case one = "less than a week"
	case two = "less than a month"
	case three = "1 to 3 months"
	case four = "more than 3 months"
	
	static let values = [one, two, three, four]
}

enum JobCategory: String {
	case one = "Menial"
	case two = "Events Coordinators"
	case three = "Creative Arts"
	case four = "Entertainment"
	case five = "Cosmetology"
	case six = "Health"
	case seven = "Legal"
	case eight = "Culinary"
	
	static let values = [one, two, three, four, five, six, seven, eight]
}

enum JobAttachType: String {
	case nothing = "nothing"
	case image = "image"
	case video = "video"
}

struct JobAttach {
	var type: JobAttachType
	
	var image: UIImage? {
		didSet {
			self.type = .image
		}
	}
	
	var videoURL: URL? {
		didSet {
			self.type = .video
		}
	}
	
	func getAttach() -> Any? {
		if self.type == .image {
			return self.image
		} else if self.type == .video {
			return self.videoURL
		} else {
			return nil
		}
	}
}

struct Job {
	var id: String?
	var title: String?
	var description: String?
	var category: JobCategory
	var deliveryTime: JobDeliverTime
	var attachment: JobAttach
	var clientID: String?
	
	init() {
		self.category = .one
		self.deliveryTime = .one
		self.attachment = JobAttach(type: .nothing, image: nil, videoURL: nil)
	}
}


class PostViewModel: NSObject {
	var job: Job = Job()
	
	override init() {
		super.init()
	}
	
	func postJob() {
		job.clientID = currentUser.id
		job.id = job.clientID! + String(format: "_%f", NSDate().timeIntervalSince1970)
	}
}
