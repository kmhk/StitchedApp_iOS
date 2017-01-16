//
//  LoginViewController.swift
//  Stitched App
//
//  Created by Com on 15/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {

	@IBOutlet weak var txtEmail: ProfileTextField!
	@IBOutlet weak var txtPassword: ProfileTextField!
	@IBOutlet weak var btnLogin: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapView(_:)))
		self.view.addGestureRecognizer(tapGesture)
		
		txtEmail.delegate = self
		txtPassword.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	func onTapView(_ sender: UITapGestureRecognizer) {
		txtEmail.resignFirstResponder()
		txtPassword.resignFirstResponder()
	}
	
	
	@IBAction func loginBtnTap(_ sender: Any) {
		MBProgressHUD.showAdded(to: self.view, animated: true)
		
		Reference.FBRef.login(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
			if error != nil {
				let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
				
				MBProgressHUD.hide(for: self.view, animated: true)
				return
			}
			
			User.getUser(fromID: user?.uid, complete: { (user) in
				currentUser = user!
				user?.saveUser()
				
				MBProgressHUD.hide(for: self.view, animated: true)
				
				if user?.role == Role.client.rawValue {
					self.performSegue(withIdentifier: "segueClient", sender: nil)
				} else {
					self.performSegue(withIdentifier: "segueVendor", sender: nil)
				}
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

}


extension LoginViewController: UITextFieldDelegate {
	
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		var dy = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height)
		dy = CGFloat(gKeyboardHeight) - dy
		guard dy > 0 else {
			return
		}
		
		UIView.animate(withDuration: 0.3, animations: {
			self.view.frame = CGRect(x: 0, y: -dy, width: self.view.frame.size.width, height: self.view.frame.size.height)
		})
	}
	
	public func textFieldDidEndEditing(_ textField: UITextField) {
		UIView.animate(withDuration: 0.3, animations: {
			self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
		})
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		if textField == txtEmail {
			txtPassword.becomeFirstResponder()
		}
		
		return true
	}
}
