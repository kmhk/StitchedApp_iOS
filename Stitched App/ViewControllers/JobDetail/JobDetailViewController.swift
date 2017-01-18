//
//  JobDetailViewController.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import MBProgressHUD

enum BidStatus {
	case non
	case bidding
	case bided
}


class JobDetailViewController: UIViewController {

	@IBOutlet weak var tableJobDetail: UITableView!
	
	var viewModel = JobDetailViewModel()
	
	var bidStatus: BidStatus = .non
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		viewModel.errorHandler = { error in
			let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
			
			MBProgressHUD.hide(for: self.view, animated: true)
		}
		
		viewModel.completeBidHandler = { [weak self] in
			let alert = UIAlertController(title: "", message: "Your proposal submitted succesfully", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self?.present(alert, animated: true, completion: nil)
			
			MBProgressHUD.hide(for: (self?.view)!, animated: true)
		}
		
		
		if currentUser.role == "vendor" {
			if viewModel.job?.bids?[currentUser.id] == nil { // not bid yet
				let barItem = UIBarButtonItem(title: "Bid Now", style: .plain, target: self, action: #selector(onBidBtnTap(_:)))
				navigationItem.rightBarButtonItems = [barItem]
				
			} else { // already bid
				bidStatus = .bided
			}
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
	
	func setJob(job: PostedJob) {
		viewModel.job = job
	}
	
	func onBidBtnTap(_ sender: Any) {
		bidStatus = .bidding
		tableJobDetail.reloadData()
		
		navigationItem.rightBarButtonItem = nil
		tableJobDetail.scrollToRow(at: IndexPath(row: 0, section: 1), at: .middle, animated: true)
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
	func numberOfSections(in tableView: UITableView) -> Int {
		if currentUser.role == "vendor" {
			return (bidStatus != .non ? 2 : 1)
		} else {
			return 2
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard section != 0 else {
			return "Job Details"
		}
		
		if currentUser.role == "vendor" {
			return "Your Proposal"
		} else {
			return "Bidders"
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if viewModel.job == nil {
			return 0
		}
		
		guard section == 0 else {
			if currentUser.role == "vendor" { // for biding cell
				return 1
			} else { // for bidder cell
				return (viewModel.job?.bids == nil ? 0: (viewModel.job?.bids?.count)!)
			}
		}
		
		return (viewModel.job?.attachType == .nothing ? 4 : 5)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		var height: CGFloat
		
		guard indexPath.section == 0 else {
			if currentUser.role == "vendor" { // for biding cell
				return tableView.frame.size.height - 50
			} else { // for bidder cell
				return 85
			}
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
		
		guard indexPath.section == 0 else {
			if currentUser.role == "vendor" { // for biding cell
				let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobBidCell.id, for: indexPath) as! DetailJobBidCell
				
				cell.bidHandler = { [weak cell] in
					cell?.txtBid.resignFirstResponder()
					
					MBProgressHUD.showAdded(to: self.view, animated: true)
					self.viewModel.bidToJob(withPropsal: (cell?.txtBid.text)!)
				}
				
				cell.setup(withJob: viewModel.job!, status: bidStatus)
				
				return cell
			}
			
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobBidderCell.id, for: indexPath) as! DetailJobBidderCell
			cell.setup(withJob: viewModel.job!, index: indexPath.row)
			return cell
		}
		
		if indexPath.row == 0 { // job id cell
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobIDCell.id, for: indexPath) as! DetailJobIDCell
			cell.lblID.text = "Job ID:  " + (viewModel.job?.id)!
			
			return cell
			
		} else if indexPath.row == 1 { // job title cell
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobTitleCell.id, for: indexPath) as! DetailJobTitleCell
			cell.lblTitle.text = (viewModel.job?.title)!
			
			return cell
			
		} else if indexPath.row == 2 { // job description cell
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobDescriptionCell.id, for: indexPath) as! DetailJobDescriptionCell
			cell.txtDescription.text = viewModel.job?.description
			
			return cell
			
		} else if indexPath.row == 3 { // job price time cell
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobInfoCell.id, for: indexPath) as! DetailJobInfoCell
			cell.lblCategory.text = "Category: " + (viewModel.job?.category.rawValue)!
			cell.lblDelivery.text = "Delivery Time: " + (viewModel.job?.deliveryTime.rawValue)!
			cell.lblPrice.text = "Budget: $" + (viewModel.job?.price)!
			
			return cell
			
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobAttachCell.id, for: indexPath) as! DetailJobAttachCell
			cell.setup(withJob: viewModel.job!)
			
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
