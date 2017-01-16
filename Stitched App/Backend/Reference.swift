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
	
	struct FBRef {
		
		static var allUsers = FIRDatabase.database().reference().child("users")
		
		static var storage = FIRStorage.storage().reference(forURL: "gs://stitchedapp.appspot.com")
		
		// MARK: user management
		static func register(withEmail email: String, password: String, completion: @escaping (_ user: FIRUser?, _ error: Error?) -> Swift.Void) {
			FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
				completion(user, error)
			})
		}
		
		
		static func login(withEmail email: String, password: String, completion: @escaping (_ user: FIRUser?, _ error: Error?) -> Swift.Void) {
			FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
				completion(user, error)
			})
		}
		
		
		static func updateUser(id: String, avatar: String, fullName: String, email: String, phone: String, role: String,
		                       completion:  @escaping (_ ref: FIRDatabaseReference?, _ error: Error?) -> Swift.Void) {
			let date = NSDate().timeIntervalSince1970
			let user = ["name": fullName,
			            "email": email,
			            "phone": phone,
			            "avatar_image": avatar,
			            "role": role,
			            "created_date": date,
			            "followers": [Any]()] as [String : Any]
			let record = [id: user]
			Reference.FBRef.allUsers.updateChildValues(record) { (error, ref) in
				completion(ref, error)
			}
		}
		
		
		static func logout() {
			do {
				try FIRAuth.auth()?.signOut()
			} catch let error {
				print("sign out with \(error)")
			}
		}
		
		
		// MARK: avatar management
		static func storageForAvatar(userID: String) -> FIRStorageReference {
			return Reference.FBRef.storage.child("userdata").child("user-" + userID).child("avatar.jpg")
		}
		
		
		static func uploadAvatarFile(withID: String, imgData: Data, completion: @escaping (_ data: FIRStorageMetadata?, _ error: Error?) -> Swift.Void) {
			let storageURL = Reference.FBRef.storageForAvatar(userID: withID)
			let metaData = FIRStorageMetadata()
			metaData.contentType = "image/jpg"
			
			storageURL.put(imgData, metadata: metaData, completion: { (data, error) in
				completion(data, error)
			})
		}
	}
	
}
