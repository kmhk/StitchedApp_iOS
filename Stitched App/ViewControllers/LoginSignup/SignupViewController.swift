//
//  SignupViewController.swift
//  Stitched App
//
//  Created by Com on 15/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

var gKeyboardHeight = (216 + 42)

class SignupViewController: UIViewController {

	@IBOutlet weak var btnProfilePhoto: UIButton!
	
	@IBOutlet weak var viewContainer: UIView!
	@IBOutlet weak var txtFullName: ProfileTextField!
	@IBOutlet weak var txtEmail: ProfileTextField!
	@IBOutlet weak var txtPhoneNumber: ProfileTextField!
	@IBOutlet weak var txtPassword: ProfileTextField!
	
	@IBOutlet weak var switchClient: UISwitch!
	
	var imgProfile: UIImage?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		txtFullName.delegate = self
		txtEmail.delegate = self
		txtPhoneNumber.delegate = self
		txtPassword.delegate = self
		
		btnProfilePhoto.layer.cornerRadius = btnProfilePhoto.frame.size.width / 2
		btnProfilePhoto.clipsToBounds = true
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapView(_:)))
		self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	@IBAction func addPhotoBtnTap(_ sender: Any) {
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
	
	@IBAction func registerBtnTap(_ sender: Any) {
		if (txtFullName.text?.lengthOfBytes(using: .utf8))! < 0 ||
			(txtEmail.text?.lengthOfBytes(using: .utf8))! < 0 ||
			(txtPhoneNumber.text?.lengthOfBytes(using: .utf8))! < 0 ||
			(txtPassword.text?.lengthOfBytes(using: .utf8))! < 0 ||
			imgProfile == nil {
			
			let alert = UIAlertController(title: "", message: "Please type your information correctly", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
		
		MBProgressHUD.showAdded(to: self.view, animated: true)
		
		let errorHandler: ((Error)->()) = { error in
			let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
			
			MBProgressHUD.hide(for: self.view, animated: true)
			return
		}
		
		let completeHandler = { [weak self] in
			MBProgressHUD.hide(for: (self?.view)!, animated: true)
			
			let alert = UIAlertController(title: "", message: "Successfully created user", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
				self?.navigationController!.popViewController(animated: true)
			}))
			self?.present(alert, animated: true, completion: nil)
			
//				DispatchQueue.main.async(execute: {
//					self.navigationController!.popViewController(animated: true)
//				})
		}
		
		Reference.FBRef.register(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
			if error != nil {
				errorHandler(error!)
				return
			}
			
			let imgData = UIImageJPEGRepresentation(self.imgProfile!, 0.5)
			Reference.FBRef.uploadAvatarFile(withID: (user?.uid)!, imgData: imgData!, completion: { (data, error) in
				if error != nil { errorHandler(error!); return }
				
				let avatarURL = data?.downloadURL()?.absoluteString
				
				var newUser = User()
				newUser.id = (user?.uid)!
				newUser.avatar = avatarURL!
				newUser.name = self.txtFullName.text!
				newUser.email = self.txtEmail.text!
				newUser.phoneNumber = self.txtPhoneNumber.text!
				newUser.role = (self.switchClient.isOn == true ? Role.client.rawValue : Role.vendor.rawValue)
				
				Reference.FBRef.updateUser(with: newUser, completion: { (ref, error) in
					if error != nil { errorHandler(error!); return }
					completeHandler()
				})
			})
			
		}
	}

	@IBAction func backBtnTap(_ sender: Any) {
		self.navigationController!.popViewController(animated: true)
	}
	
	func onTapView(_ sender: UITapGestureRecognizer) {
		txtFullName.resignFirstResponder()
		txtEmail.resignFirstResponder()
		txtPhoneNumber.resignFirstResponder()
		txtPassword.resignFirstResponder()
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	
	// MARK: - private methods
	
	private func register(withEmail: String, password: String, completion: @escaping () -> Swift.Void) {
		
	}
}


extension SignupViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
			self.imgProfile = pickedImage
			
			self.btnProfilePhoto.setImage(pickedImage, for: .normal)
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}


extension SignupViewController: UITextFieldDelegate {
	
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		var dy = viewContainer.frame.size.height - (textField.frame.origin.y + textField.frame.size.height)
		dy = CGFloat(gKeyboardHeight) - dy
		guard dy > 0 else {
			return
		}
		
		UIView.animate(withDuration: 0.3, animations: { 
			self.viewContainer.frame = CGRect(x: 0, y: -dy, width: self.viewContainer.frame.size.width, height: self.viewContainer.frame.size.height)
		})
	}
	
	public func textFieldDidEndEditing(_ textField: UITextField) {
		UIView.animate(withDuration: 0.3, animations: {
			self.viewContainer.frame = CGRect(x: 0, y: 0, width: self.viewContainer.frame.size.width, height: self.viewContainer.frame.size.height)
		})
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		if textField == txtFullName {
			txtEmail.becomeFirstResponder()
		} else if textField == txtEmail {
			txtPhoneNumber.becomeFirstResponder()
		} else if textField == txtPhoneNumber {
			txtPassword.becomeFirstResponder()
		}
		
		return true
	}
}
