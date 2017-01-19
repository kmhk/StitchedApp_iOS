//
//  CommunityViewController.swift
//  Stitched App
//
//  Created by Com on 19/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {
	
	var viewModel = CommunityViewModel()

	@IBOutlet weak var tableHistory: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel.completeHandler = { [weak self] in
			self?.tableHistory.reloadData()
		}
		
		viewModel.newMessageReceivedHandler = { [weak self] in
			if self?.navigationController?.tabBarController?.selectedViewController != self?.navigationController {
//				let cur = self?.navigationController?.tabBarItem.badgeValue
//				let badge = (cur == nil ? 1 : Int(cur!)!+1)
//				self?.navigationController?.tabBarItem.badgeValue = String(badge)
				self?.navigationController?.tabBarItem.badgeValue = "1"
			} else {
				self?.navigationController?.tabBarItem.badgeValue = nil
			}
		}
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.tabBarItem.badgeValue = nil
		
		viewModel.loadAllChatRoom()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.tableHistory.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "segueChat" {
			let vc = segue.destination as! ChatViewController
			vc.viewModel.chatRoomID = viewModel.roomIDs[(sender as! IndexPath).row]
		}
    }

}

extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.roomIDs.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.id, for: indexPath) as! CommunityTableViewCell
		//cell.textLabel?.text = viewModel.roomIDs[indexPath.row]
		cell.setup(with: viewModel.users[indexPath.row])
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		performSegue(withIdentifier: "segueChat", sender: indexPath)
	}
}
