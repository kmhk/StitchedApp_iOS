//
//  ChatViewController.swift
//  Stitched App
//
//  Created by Com on 19/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import Nuke

class ChatViewController: UIViewController {
	
	var viewModel = ChatViewModel()
	
	@IBOutlet weak var viewHistory: UIScrollView!
	@IBOutlet weak var txtText: UITextField!
	@IBOutlet weak var viewInput: UIView!
	
	var yPos: CGFloat = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel.showChat = { [weak self] in
			self?.showChatHistory()
		}
		
		viewHistory.delegate = self
		txtText.delegate = self
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.loadChatHistory(from: viewModel.chatRoomID!)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		txtText.becomeFirstResponder()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func sendBtnTap(_ sender: Any) {
		guard (txtText.text?.lengthOfBytes(using: .utf8))! > 0 else { return }
		
		viewModel.sendMyMsg(msg: txtText.text!)
		txtText.text = ""
	}
	
	func showChatHistory() {
		guard viewModel.history.count >= 0 else { return }
		
		for i in viewModel.received..<viewModel.history.count {
			let entry = viewModel.history[i]
			drawChat(with: entry)
		}
		
		viewModel.received = viewModel.history.count
	}
	
	func drawChat(with entry: ChatEntry) {
		// create avatar view
		let avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
		avatar.image = UIImage(named: "avatarIcon")
		avatar.layer.cornerRadius = avatar.frame.size.width / 2
		avatar.layer.borderWidth = 1.0
		avatar.clipsToBounds = true
		
		let lblName = UILabel(frame: CGRect(x: 0, y: 5, width: 44, height: 15))
		lblName.font = UIFont.systemFont(ofSize: 6)
		lblName.alpha = 0.7
		
		// create mesasge view
		let rt = (entry.message as NSString).size(attributes: [NSFontAttributeName: Utils.regularFont()])
		let maxW = viewHistory.frame.size.width / 2
		let maxH = rt.height
		let tmp = rt.width / maxW
		let lines = Int(tmp) + (tmp - CGFloat(Int(tmp)) > 0 ? 2: 1)
		let lblMsg = UILabel(frame: CGRect(x: 9, y: 9, width: (rt.width < maxW ? rt.width : maxW), height: maxH * CGFloat(lines)))
		lblMsg.numberOfLines = lines
		lblMsg.font = Utils.regularFont()
		lblMsg.text = entry.message
		
		let viewMsg = UIView(frame: CGRect(x: 0, y: 0, width: lblMsg.frame.size.width + 18, height: lblMsg.frame.size.height + 18))
		viewMsg.backgroundColor = UIColor.groupTableViewBackground
		viewMsg.layer.cornerRadius = 8.0
		viewMsg.layer.borderWidth = 1.0
		viewMsg.layer.borderColor = UIColor.lightGray.cgColor
		viewMsg.clipsToBounds = true
		viewMsg.addSubview(lblMsg)
		
		let yPadding: CGFloat = 10
		let xPadding: CGFloat = 10
		if entry.who == .me { // draw my message
			avatar.frame = CGRect(x: viewHistory.frame.size.width - xPadding - avatar.frame.size.width,
			                      y: yPos + yPadding,
			                      width: avatar.frame.size.width,
			                      height: avatar.frame.size.height)
			
			lblName.textAlignment = .right
			lblName.text = "ME"
			lblName.textColor = UIColor.green
			lblName.frame = CGRect(x: avatar.frame.origin.x, y: yPos, width: lblName.frame.size.width, height: lblName.frame.size.height)
			
			viewMsg.frame = CGRect(x: viewHistory.frame.size.width - xPadding * 2 - avatar.frame.size.width - viewMsg.frame.size.width,
			                      y: yPos + yPadding,
			                      width: viewMsg.frame.size.width,
			                      height: viewMsg.frame.size.height)
			lblMsg.textAlignment = .right
			
			let req = Request(url: URL(string: currentUser.avatar)!)
			Nuke.loadImage(with: req, into: avatar)
			
		} else { // draw opponent message
			avatar.frame = CGRect(x: xPadding,
			                      y: yPos + yPadding,
			                      width: avatar.frame.size.width,
			                      height: avatar.frame.size.height)
			
			lblName.textAlignment = .left
			lblName.text = viewModel.opponent?.name
			lblName.textColor = UIColor.blue
			lblName.frame = CGRect(x: avatar.frame.origin.x, y: yPos, width: lblName.frame.size.width, height: lblName.frame.size.height)
			
			viewMsg.frame = CGRect(x: xPadding * 2 + avatar.frame.size.width,
			                      y: yPos + yPadding,
			                      width: viewMsg.frame.size.width,
			                      height: viewMsg.frame.size.height)
			lblMsg.textAlignment = .left
			
			let req = Request(url: URL(string: (viewModel.opponent?.avatar)!)!)
			Nuke.loadImage(with: req, into: avatar)
		}
		
		viewHistory.addSubview(avatar)
		viewHistory.addSubview(viewMsg)
		viewHistory.addSubview(lblName)
		
		// set scroll pos
		let h = max(avatar.frame.size.height, viewMsg.frame.size.height)
		yPos = yPos + yPadding + h + yPadding
		
		viewHistory.contentSize = CGSize(width: viewHistory.contentSize.width,
		                                 height: max(yPos, viewHistory.contentSize.height))
		
		if yPos > viewHistory.frame.size.height {
			viewHistory.setContentOffset(CGPoint(x: 0, y: viewHistory.contentSize.height - viewHistory.frame.size.height),
			                             animated: true)
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController: UITextFieldDelegate {
//	public func textFieldDidBeginEditing(_ textField: UITextField) {
//		UIView.animate(withDuration: 0.3, animations: {
//			self.view.frame = CGRect(x: 0, y: CGFloat(-gKeyboardHeight), width: self.view.frame.size.width, height: self.view.frame.size.height)
//		})
//	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		sendBtnTap(self)
		
		return true
	}
	
//	public func textFieldDidEndEditing(_ textField: UITextField) {
//		UIView.animate(withDuration: 0.3, animations: {
//			self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//		})
//	}
}

extension ChatViewController: UIScrollViewDelegate {
//	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		UIView.animate(withDuration: 0.3, animations: {
//			self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//		})
//	}
}
