//
//  PostViewController.swift
//  Stitched App
//
//  Created by Com on 17/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import MobileCoreServices
import MBProgressHUD

class PostViewController: UIViewController {
	
	var viewModel = PostViewModel()

	@IBOutlet weak var tableViewPost: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel.errorHandler = { error in
			let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
			
			MBProgressHUD.hide(for: self.view, animated: true)
		}
		
		viewModel.completeHandler = { [weak self] in
			let alert = UIAlertController(title: "", message: "Your job posted successfully", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self?.present(alert, animated: true, completion: nil)
			
			self?.viewModel.clearJobDetail()
			self?.tableViewPost.reloadData()
			
			MBProgressHUD.hide(for: (self?.view)!, animated: true)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func postBtnTap(_ sender: Any) {
		if viewModel.job.title == "" || viewModel.job.description == "" || viewModel.job.price == "" {
			let alert = UIAlertController(title: "", message: "Please type your job title, description and price", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		MBProgressHUD.showAdded(to: self.view, animated: true)
		
		viewModel.postJob()
	}

	func onTakeAttachment() {
		let actionSheet = UIAlertController(title: "", message: "Choose your attachment", preferredStyle: .actionSheet)
		
		actionSheet.addAction(UIAlertAction(title: "Take from camera", style: .default, handler: { (action) in
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			imagePicker.videoQuality = .typeMedium
			imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
			imagePicker.sourceType = .camera
			self.present(imagePicker, animated: true, completion: nil)
		}))
		
		actionSheet.addAction(UIAlertAction(title: "Choose a existing one", style: .default, handler: { (action) in
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			imagePicker.videoQuality = .typeMedium
			imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
			self.present(imagePicker, animated: true, completion: nil)
		}))
		
		actionSheet.addAction(UIAlertAction(title: "Remove attachment", style: .default, handler: { (action) in
			self.viewModel.job.attachment.type = .nothing
			self.tableViewPost.reloadData()
		}))
		
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
			
		}))
		
		self.present(actionSheet, animated: true, completion: nil)
	}
}


extension PostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		if (info[UIImagePickerControllerMediaType] as! NSString).isEqual(to: kUTTypeImage as String) == true {
			if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
				self.viewModel.job.attachment.image = pickedImage
			}
			
		} else if (info[UIImagePickerControllerMediaType] as! NSString).isEqual(to: kUTTypeMovie as String) == true {
			if let fileURL = info[UIImagePickerControllerMediaURL] as! NSURL! {
				self.viewModel.job.attachment.videoURL = fileURL as URL
			}
		}
		
		dismiss(animated: true) {
			self.tableViewPost.reloadData()
		}
	}
	
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}


extension PostViewController: UITableViewDelegate, UITableViewDataSource {
	func resignTextField() {
		let cell = self.tableViewPost.cellForRow(at: IndexPath(item: 0, section: 1)) as? PostJobTitleCell
		if cell != nil {
			viewModel.job.title = cell?.txtTitle.text
			cell?.txtTitle.resignFirstResponder()
		}
		
		let cell1 = self.tableViewPost.cellForRow(at: IndexPath(item: 0, section: 2)) as? PostJobDescriptionCell
		if cell1 != nil {
			viewModel.job.description = cell1?.txtDescription.text
			cell1?.txtDescription.resignFirstResponder()
		}
		
		let cell2 = self.tableViewPost.cellForRow(at: IndexPath(item: 0, section: 3)) as? PostJobPriceCell
		if cell2 != nil {
			viewModel.job.price = cell2?.txtPrice.text
			cell2?.txtPrice.resignFirstResponder()
		}
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
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		resignTextField()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 6
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var headerTitle: String
		
		if section == 0 { // job category cell
			headerTitle = "Category"
		} else if section == 1 { // job title cell
			headerTitle = "Title"
		} else if section == 2 { // job description cell
			headerTitle = "Description"
		} else if section == 3 { // job price cell
			headerTitle = "Price"
		} else if section == 4 { // job delivery time cell
			headerTitle = "Deliver Time"
		} else {
			headerTitle = "Attachment"
		}
		
		return headerTitle
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		var height: CGFloat
		
		if indexPath.section == 0 { // job category cell
			height = 40
			
		} else if indexPath.section == 1 { // job title cell
			height = 40
			
		} else if indexPath.section == 2 { // job description cell
			height = 100
			
		} else if indexPath.section == 3 { // job price cell
			height = 40
			
		} else if indexPath.section == 4 { // job delivery time cell
			height = 40
			
		} else {
			height = tableView.frame.size.width - 20
		}
		
		return height
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.section == 0 { // job category cell
			let cell = tableView.dequeueReusableCell(withIdentifier: PostJobCategoryCell.id, for: indexPath) as! PostJobCategoryCell
			cell.textLabel?.text = viewModel.job.category.rawValue
			cell.textLabel?.font = Utils.regularFont()
			
			return cell
			
		} else if indexPath.section == 1 { // job title cell
			let cell = tableView.dequeueReusableCell(withIdentifier: PostJobTitleCell.id, for: indexPath) as! PostJobTitleCell
			cell.txtTitle.text = viewModel.job.title
			cell.txtTitle.font = Utils.regularFont()
			
			return cell
			
		} else if indexPath.section == 2 { // job description cell
			let cell = tableView.dequeueReusableCell(withIdentifier: PostJobDescriptionCell.id, for: indexPath) as! PostJobDescriptionCell
			cell.txtDescription.placeholder = "eg. I am looking for translator my theory in English."
			cell.txtDescription.text = viewModel.job.description
			
			return cell
			
		} else if indexPath.section == 3 { // job price time cell
			let cell = tableView.dequeueReusableCell(withIdentifier: PostJobPriceCell.id, for: indexPath) as! PostJobPriceCell
			cell.txtPrice.text = viewModel.job.price
			cell.txtPrice.font = Utils.regularFont()
			
			return cell
			
		} else if indexPath.section == 4 { // job delivery time cell
			let cell = tableView.dequeueReusableCell(withIdentifier: PostJobDeliveryTimeCell.id, for: indexPath) as! PostJobDeliveryTimeCell
			cell.textLabel?.text = viewModel.job.deliveryTime.rawValue
			cell.textLabel?.font = Utils.regularFont()
			
			return cell
			
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: PostJobAttachCell.id, for: indexPath) as! PostJobAttachCell
			cell.setAttchment(attach: viewModel.job.attachment)
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		resignTextField()
		
		if indexPath.section == 0 { // job category cell
			showPickerView(curText: viewModel.job.category.rawValue, section: indexPath.section)
			
		} else if indexPath.section == 1 { // job title cell
			
		} else if indexPath.section == 2 { // job description cell
			
		} else if indexPath.section == 3 { // job price cell
			
		} else if indexPath.section == 4 { // job delivery time cell
			showPickerView(curText: viewModel.job.deliveryTime.rawValue, section: indexPath.section)
			
		} else {
			onTakeAttachment()
		}
	}
}


extension PostViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
			viewModel.job.category = JobCategory.values[row]
		} else {
			viewModel.job.deliveryTime = JobDeliverTime.values[row]
		}
		
		tableViewPost.reloadData()
	}
}
