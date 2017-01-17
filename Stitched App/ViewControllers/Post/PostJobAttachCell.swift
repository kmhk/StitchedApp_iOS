//
//  PostJobAttachCell.swift
//  Stitched App
//
//  Created by Com on 17/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PostJobAttachCell: UITableViewCell {
	
	static var id = "PostJobAttachCell"
	
	var attachment: JobAttach?
	var playerController: AVPlayerViewController?
	
	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var videoView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setAttchment(attach: JobAttach?) {
		self.attachment = attach
		guard attachment != nil else {
			imgView.isHidden = true
			videoView.isHidden = true
			return
		}
		
		if attachment?.type == .nothing {
			imgView.isHidden = true
			videoView.isHidden = true
			return
		}
		
		if attachment?.type == .image {
			imgView.isHidden = false
			videoView.isHidden = true
			
			imgView.image = attachment?.getAttach() as! UIImage?
			
		} else {
			imgView.isHidden = true
			videoView.isHidden = false
			
			let player = AVPlayer(url: attachment?.getAttach() as! URL)
			playerController = AVPlayerViewController()
			playerController?.player = player
			videoView.addSubview((playerController?.view)!)
			playerController?.view.frame = videoView.bounds
		}
	}
}
