//
//  JobDetailViewController.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class JobDetailViewController: UIViewController {

	@IBOutlet weak var tableJobDetail: UITableView!
	
	var job: PostedJob?
	var isBidding: Bool = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		if currentUser.role == "vendor" {
			let barItem = UIBarButtonItem(title: "Bid Now", style: .plain, target: self, action: #selector(onBidBtnTap(_:)))
			navigationItem.rightBarButtonItems = [barItem]
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		tableJobDetail.reloadData()
	}
	
	func onBidBtnTap(_ sender: Any) {
		isBidding = true
		tableJobDetail.reloadData()
		
		navigationItem.rightBarButtonItem = nil
		tableJobDetail.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
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

extension JobDetailViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard section == 0 else { return 1 } // for biding cell
		
		if job == nil {
			return 0
		}
		
		return (job?.attachType == .nothing ? 4 : 5)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return (isBidding == true ? 2 : 1)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		var height: CGFloat
		
		guard indexPath.section == 0 else { // for biding cell
			return tableView.frame.size.height - 50
		}
		
		if indexPath.row == 0 { // job id cell
			height = 60
			
		} else if indexPath.row == 1 { // job title cell
			height = 90
			
		} else if indexPath.row == 2 { // job description cell
			height = 200
			
		} else if indexPath.row == 3 { // job info cell
			height = 96
			
		} else {
			height = tableView.frame.size.width - 20
		}
		
		return height
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard indexPath.section == 0 else { // for biding cell
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobBidCell.id, for: indexPath) as! DetailJobBidCell
			cell.txtBid.text = ""
			cell.txtBid.placeholder = "Please type your proposal here"
			cell.txtBid.becomeFirstResponder()
			cell.bidHandler = { [weak cell] in
				cell?.txtBid.resignFirstResponder()
			}
			
			return cell
		}
		
		if indexPath.row == 0 { // job id cell
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobIDCell.id, for: indexPath) as! DetailJobIDCell
			cell.lblID.text = "Job ID:  " + (job?.id)!
			
			return cell
			
		} else if indexPath.row == 1 { // job title cell
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobTitleCell.id, for: indexPath) as! DetailJobTitleCell
			cell.lblTitle.text = (job?.title)!
			
			return cell
			
		} else if indexPath.row == 2 { // job description cell
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobDescriptionCell.id, for: indexPath) as! DetailJobDescriptionCell
			cell.txtDescription.text = job?.description
			
			return cell
			
		} else if indexPath.row == 3 { // job price time cell
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobInfoCell.id, for: indexPath) as! DetailJobInfoCell
			cell.lblCategory.text = "Category: " + (job?.category.rawValue)!
			cell.lblDelivery.text = "Delivery Time: " + (job?.deliveryTime.rawValue)!
			cell.lblPrice.text = "Budget: $" + (job?.price)!
			
			return cell
			
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobAttachCell.id, for: indexPath) as! DetailJobAttachCell
			cell.setup(withJob: job!)
			
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
