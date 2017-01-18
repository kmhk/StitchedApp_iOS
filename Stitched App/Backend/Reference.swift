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
		
		static var allJobs = FIRDatabase.database().reference().child("jobs")
		
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
		
		
		static func updateUser(with usr: User, completion:  @escaping (_ ref: FIRDatabaseReference?, _ error: Error?) -> Swift.Void) {
			let date = NSDate().timeIntervalSince1970
			let user = ["name": usr.name,
			            "email": usr.email,
			            "phone": usr.phoneNumber,
			            "avatar_image": usr.avatar,
			            "role": usr.role,
			            "created_date": date,
			            "ranking": usr.ranking,
			            "follower": "\(usr.follower)",
						"network": "\(usr.network)",
			            "followers": [Any]()] as [String : Any]
			let record = [usr.id: user]
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
		
		
		// MARK: job management
		static func loadPostedJob(Of user: User?, forUser: User?, completion: @escaping (_ jobs: [PostedJob]) -> Swift.Void) {
			Reference.FBRef.allJobs.observe(.value, with: { (snap) in
				let allItems = snap.value as! [String: AnyObject]!
				
				var jobs = [PostedJob]()
				
				for key in (allItems?.keys)! {
					let each = allItems?[key] as! [String: AnyObject]!
					
					var aJob = PostedJob()
					aJob.id = key
					aJob.title = each?["title"] as! String?
					aJob.description = each?["description"] as! String?
					aJob.category = JobCategory(s: (each?["category"] as! String?)!)
					aJob.deliveryTime = JobDeliverTime(s: (each?["deliverTime"] as! String?)!)
					aJob.price = each?["price"] as! String?
					aJob.attachType = JobAttachType(s: (each?["attachType"] as! String?)!)
					aJob.attachURL = each?["attachURL"] as! String?
					aJob.clientID = each?["owner"] as! String?
					
					if each?["bids"] != nil {
						let bids = each?["bids"] as! [String: AnyObject]!
						aJob.bids = bids
					}
					
					if user?.id == each?["owner"] as! String? || (user == nil && forUser == nil) {
						jobs.append(aJob)
						
					} else if forUser != nil && aJob.bids?[(forUser?.id)!] != nil {
						jobs.append(aJob)
					}
				}
				
				completion(jobs)
			})
		}
		
		static func storageForJobAttach(jobID: String) -> FIRStorageReference {
			return Reference.FBRef.storage.child("jobattach").child(jobID)
		}
		
		
		static func uploadJobAttach(withID: String, data: Data, type: JobAttachType, completion: @escaping (_ data: FIRStorageMetadata?, _ error: Error?) -> Swift.Void) {
			let storageURL = Reference.FBRef.storageForJobAttach(jobID: withID).child("attach." + type.rawValue)
			let metaData = FIRStorageMetadata()
			metaData.contentType = (type == .image ? "image/jpg" : "video/quicktime")
			
			storageURL.put(data, metadata: metaData) { (data, error) in
				completion(data, error)
			}
		}
		
		
		static func uploadJob(withJob: Job, attachURL: String, completion:  @escaping (_ ref: FIRDatabaseReference?, _ error: Error?) -> Swift.Void) {
			let date = NSDate().timeIntervalSince1970
			let job = ["title": withJob.title!,
			           "description": withJob.description!,
			           "category": withJob.category.rawValue,
			           "deliverTime": withJob.deliveryTime.rawValue,
			           "price": withJob.price!,
			           "owner": withJob.clientID!,
			           "attachType": withJob.attachment.type.rawValue,
			           "attachURL": attachURL,
			           "created_date": date] as [String: Any]
			let record = [withJob.id! : job]
			
			Reference.FBRef.allJobs.updateChildValues(record) { (error, ref) in
				completion(ref, error)
			}
		}
		
		
		// MARK: bid to job
		static func bidTo(Job job: PostedJob, user: User, propsal: String, completion:  @escaping (_ ref: FIRDatabaseReference?, _ error: Error?) -> Swift.Void) {
			let date = NSDate().timeIntervalSince1970
			let bid = ["created_date": date,
			           "proposal": propsal] as [String: Any]
			let record = [user.id: bid]
			Reference.FBRef.allJobs.child(job.id!).child("bids").updateChildValues(record) { (error, ref) in
				completion(ref, error)
			}
		}
	}
	
}
