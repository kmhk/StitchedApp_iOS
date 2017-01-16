//
//  FirebaseRef.swift
//  Stitched App
//
//  Created by Com on 16/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import Firebase

struct Reference {
	
	struct firebaseRef {
		
		static var allUsers = FIRDatabase.database().reference().child("users")
		
		static var storage = FIRStorage.storage().reference(forURL: "gs://stitchedapp.appspot.com")
		
		static func register(withEmail email: String, password: String, completion: @escaping (_ user: FIRUser?, _ error: Error?) -> Swift.Void) {
			FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
				completion(user, error)
			})
		}
		
		static func storageForAvatar(userID: String) -> FIRStorageReference {
			return Reference.firebaseRef.storage.child("userdata").child("user-" + userID).child("avatar.jpg")
		}
		
		static func addNewUser(id: String, avatar: String, fullName: String, email: String, phone: String, role: String) {
			let date = NSDate().timeIntervalSince1970
			let user = ["name": fullName,
			            "email": email,
			            "phone": phone,
			            "avatar_image": avatar,
			            "role": role,
			            "created_date": date,
			            "followers": [Any]()] as [String : Any]
			let record = [id: user]
			Reference.firebaseRef.allUsers.updateChildValues(record)
		}
	}
}
