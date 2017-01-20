//
//  DirectHireViewController.swift
//  Stitched App
//
//  Created by Com on 20/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class DirectHireViewController: UIViewController {
	
	var viewModel = DirectHireViewModel()
	
	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel.completeHandler = { [weak self] in
			self?.tableView.reloadData()
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.getAllUsers()
	}


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "segueProfile" {
			let vc = segue.destination as! NavProfileViewController
			vc.user = sender as! User!
			
		} else if segue.identifier == "segueChat" {
			let vc = segue.destination as! ChatViewController
			vc.viewModel.chatRoomID = currentUser.id + "+" + ((sender as! User!)?.id)!
		}
    }
}


extension DirectHireViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Choose Category"
		} else {
			return "Vendors"
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return viewModel.users.count
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 54
		} else {
			return 85
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: DirectHireCategoryCell.id, for: indexPath) as! DirectHireCategoryCell
			cell.textLabel?.text = viewModel.category.rawValue
			return cell
			
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: DetailJobBidderCell.id, for: indexPath) as! DetailJobBidderCell
			cell.chatHandler = { [weak self] in
				self?.performSegue(withIdentifier: "segueChat", sender: self?.viewModel.users[indexPath.row])
			}
			cell.hireHandler = {
			}
			
			cell.setup(withUser: viewModel.users[indexPath.row])
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if indexPath.section == 0 {
			showPickerView(curText: "", section: indexPath.section)
			
		} else {
			let cell = tableView.cellForRow(at: indexPath) as! DetailJobBidderCell
			
			self.performSegue(withIdentifier: "segueProfile", sender: cell.user)
		}
	}
}


extension DirectHireViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		let section = pickerView.tag - 0x100
		if section == 0 {
			return JobCategory.values.count
		} else {
			return JobDeliverTime.values.count
		}
	}
	
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let section = pickerView.tag - 0x100
		if section == 0 {
			return JobCategory.values[row].rawValue
		} else {
			return JobDeliverTime.values[row].rawValue
		}
	}
	
	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let section = pickerView.tag - 0x100
		
		if section == 0 {
			viewModel.category = JobCategory.values[row]
		}
		
		tableView.reloadData()
	}
	
	func showPickerView(curText: String, section: Int) {
		let containerView = UIView(frame: view.frame)
		containerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
		containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPickerDoneBtnTap(_:))))
		containerView.tag = 0x1000
		
		let inputView = UIView(frame: CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 216 + 44))
		inputView.tag = 0x100
		containerView.addSubview(inputView)
		
		let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
		toolbar.items = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onPickerDoneBtnTap(_:)))]
		inputView.addSubview(toolbar)
		
		let picker = UIPickerView(frame: CGRect(x: 0, y: 44, width: view.frame.size.width, height: 216))
		picker.delegate = self
		picker.backgroundColor = UIColor.lightGray
		picker.tag = 0x100 + section
		inputView.addSubview(picker)
		
		containerView.alpha = 0.0
		self.navigationController?.view.addSubview(containerView)
		
		UIView.animate(withDuration: 0.1, animations: {
			containerView.alpha = 1.0
		}) { (flag) in
			UIView.animate(withDuration: 0.2) {
				inputView.frame = CGRect(x: 0, y: self.view.frame.size.height - 216 - 44, width: self.view.frame.size.width, height: 216 + 44)
			}
		}
	}
	
	func onPickerDoneBtnTap(_ sender: Any) {
		let containerView = self.navigationController?.view.viewWithTag(0x1000)
		let inputView = containerView?.viewWithTag(0x100)
		
		UIView.animate(withDuration: 0.1, animations: {
			inputView?.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 216 + 44)
		}) { (flag) in
			UIView.animate(withDuration: 0.1, animations: {
				containerView?.alpha = 0.0
			}, completion: { (flag) in
				containerView?.removeFromSuperview()
			})
		}
	}
}
