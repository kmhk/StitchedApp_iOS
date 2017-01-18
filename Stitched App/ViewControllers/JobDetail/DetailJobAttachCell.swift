//
//  DetailJobAttachCell.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Nuke


class DetailJobAttachCell: UITableViewCell {
	
	static var id = "DetailJobAttachCell"

	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var viewContainer: UIView!
	
	var playerController: AVPlayerViewController?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setup(withJob job: PostedJob) {
		if job.attachType == .image {
			imgView.isHidden = false
			viewContainer.isHidden = true
			
			var req = Request(url: URL(string: job.attachURL!)!)
			req.memoryCacheOptions.readAllowed = false
			req.memoryCacheOptions.writeAllowed = false
			Nuke.loadImage(with: req, into: imgView)
			
		} else {
			imgView.isHidden = true
			viewContainer.isHidden = false
			
			let player = AVPlayer(url: URL(string: job.attachURL!)!)
			playerController = AVPlayerViewController()
			playerController?.player = player
			viewContainer.addSubview((playerController?.view)!)
			playerController?.view.frame = viewContainer.bounds
		}
	}
}
