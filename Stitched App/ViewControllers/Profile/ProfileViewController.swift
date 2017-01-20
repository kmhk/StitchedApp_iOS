//
//  ProfileViewController.swift
//  Stitched App
//
//  Created by Com on 16/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import MBProgressHUD
import Nuke
import MapKit

class ProfileViewController: UIViewController {
	
	
	@IBOutlet weak var imgViewAvatar: UIImageView!
	@IBOutlet weak var lblDescription: UILabel!
	@IBOutlet weak var txtName: ProfileTextField!
	@IBOutlet weak var txtEmail: ProfileTextField!
	@IBOutlet weak var txtPhoneNumber: ProfileTextField!
	@IBOutlet weak var lblProfileID: UILabel!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var btnSave: UIButton!
	
	var user: User?
	var isChangedAvatar: Bool = false

	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		imgViewAvatar.layer.cornerRadius = imgViewAvatar.frame.size.width / 2
		imgViewAvatar.layer.borderWidth = 1.0
		imgViewAvatar.layer.borderColor = UIColor.black.cgColor
		imgViewAvatar.clipsToBounds = true
		
		mapView.layer.borderWidth = 1.0
		mapView.layer.borderColor = UIColor.lightGray.cgColor
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(onTapAvatarImage(_:)))
		imgViewAvatar.addGestureRecognizer(tap)
		
		if (self.navigationController as! NavProfileViewController).user == nil {
			setUser(withID: nil)
			
		} else {
			user = (self.navigationController as! NavProfileViewController).user
			
			txtName.isEnabled = false
			txtEmail.isEnabled = false
			txtPhoneNumber.isEnabled = false
			btnSave.isHidden = true
			
			imgViewAvatar.isUserInteractionEnabled = false
			
			navigationItem.title = "Profile"
			
			let barItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(onClose(_:)))
			navigationItem.leftBarButtonItems = [barItem]
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if isChangedAvatar == false {
			showProfile()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		isChangedAvatar = false
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	public func setUser(with usr: User?) {
		guard user != nil else { return	}
		
		txtName.isEnabled = false
		txtEmail.isEnabled = false
		txtPhoneNumber.isEnabled = false
		btnSave.isHidden = true
		
		imgViewAvatar.isUserInteractionEnabled = false
		
		self.user = usr
		
		self.showProfile()
	}
	
	public func setUser(withID: String?) {
		if withID == currentUser.id || withID == nil {
			user = currentUser
			showProfile()
			
			let barItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(onLogout(_:)))
			navigationItem.rightBarButtonItems = [barItem]
			
			imgViewAvatar.isUserInteractionEnabled = true
			
		} else {
			txtName.isEnabled = false
			txtEmail.isEnabled = false
			txtPhoneNumber.isEnabled = false
			btnSave.isHidden = true
			
			imgViewAvatar.isUserInteractionEnabled = false
			
			User.getUser(fromID: withID, complete: { (user) in
				self.user = user
				
				self.showProfile()
			})
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

	
	@IBAction func saveProfileBtnTap(_ sender: Any) {
		if isChangedAvatar == false &&
			txtName.text == user?.name &&
			txtEmail.text == user?.email &&
			txtPhoneNumber.text == user?.phoneNumber {
			return
		}
		
		let errorHandler: ((Error)->()) = { error in
			let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
			
			MBProgressHUD.hide(for: self.view, animated: true)
			return
		}
		
		let updateUser: ((String)->()) = { avatarURL in
			var newData = self.user
			newData?.avatar = avatarURL
			newData?.name = self.txtName.text!
			newData?.email = self.txtEmail.text!
			newData?.phoneNumber = self.txtPhoneNumber.text!
			
			Reference.FBRef.updateUser(with:  newData!, completion: { (ref, error) in
					if error != nil { errorHandler(error!) }
										
					MBProgressHUD.hide(for: (self.view)!, animated: true)
					
					currentUser = newData!
					currentUser.saveUser()
										
					let alert = UIAlertController(title: "", message: "Updating profile successfully", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
					self.present(alert, animated: true, completion: nil)
				
					self.user = currentUser
			})
		}
		
		MBProgressHUD.showAdded(to: self.view, animated: true)
		
		if isChangedAvatar == true {
			
			let imgData = UIImageJPEGRepresentation(imgViewAvatar.image!, 0.5)
			Reference.FBRef.uploadAvatarFile(withID: (user?.id)!, imgData: imgData!, completion: { (data, error) in
				if error != nil { errorHandler(error!) }
				
				let avatarURL = data?.downloadURL()?.absoluteString
				updateUser(avatarURL!)
			})
			
		} else {
			updateUser((user?.avatar)!)
		}
	}
	
	func onClose(_ sender: Any) {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
	func onLogout(_ sender: Any) {
		let action = UIAlertController(title: "", message: "Are you sure sign out?", preferredStyle: .alert)
		
		action.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
			Reference.FBRef.logout()
			currentUser.id = ""
			self.navigationController?.tabBarController?.navigationController?.popViewController(animated: true)
		}))
		action.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
		
		present(action, animated: true, completion: nil)
	}
	
	func onTapAvatarImage(_ sender: Any) {
		let actionSheet = UIAlertController(title: "", message: "Choose your profile photo", preferredStyle: .actionSheet)
		
		actionSheet.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { (action) in
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			imagePicker.sourceType = .camera
			self.present(imagePicker, animated: true, completion: nil)
		}))
		
		actionSheet.addAction(UIAlertAction(title: "Choose a existing photo", style: .default, handler: { (action) in
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}))
		
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
			
		}))
		
		self.present(actionSheet, animated: true, completion: nil)
	}
	
	
	// MARK: private methods
	
	private func showProfile() {
		guard user != nil else { return	}
		
		var req = Request(url: URL(string: (user?.avatar)!)!)
		req.memoryCacheOptions.readAllowed = false
		req.memoryCacheOptions.writeAllowed = false
		Nuke.loadImage(with: req, into: imgViewAvatar)
		
		lblProfileID.text = "Profile ID:  " + (user?.id)!
		lblDescription.text = (user?.role == Role.client.rawValue ? "Client. Available posting a job" : "Vendor. Available biding to a job")
		txtName.text = user?.name
		txtEmail.text = user?.email
		txtPhoneNumber.text = user?.phoneNumber
		
		if user?.id != currentUser.id {
			if user?.location.latitude == currentUser.location.latitude &&
				user?.location.longitude == currentUser.location.longitude {
				let alert = UIAlertController(title: "", message: "You have reached to him", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
			}
		}
		
		centerMapOnLocation(location: currentUser.location)
	}
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		var image: UIImage?
		if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
			image = pickedImage
		}
		
		self.isChangedAvatar = true
		dismiss(animated: true) {
			if image != nil {
				self.imgViewAvatar.image = image
			}
		}
	}
	
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}


extension ProfileViewController: MKMapViewDelegate {
	public func centerMapOnLocation(location: CLLocationCoordinate2D) {
		let regionRadius: CLLocationDistance = 1000
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
		                                                          regionRadius * 2.0, regionRadius * 2.0)
		mapView.setRegion(coordinateRegion, animated: true)
		
		mapView.showsUserLocation = true
		
		if user?.id != currentUser.id {
			let artwork = Artwork(name: (user?.name)!, coordinate: (user?.location)!)
			mapView.addAnnotation(artwork)
		}
	}
	
}


class Artwork: NSObject, MKAnnotation {
	var name: String
	var coordinate: CLLocationCoordinate2D
 
	init(name: String, coordinate: CLLocationCoordinate2D) {
		self.name = name
		self.coordinate = coordinate
		
		super.init()
	}
}
