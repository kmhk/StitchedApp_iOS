//
//  HomeViewController.swift
//  Stitched App
//
//  Created by Com on 15/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
	
	var viewModel = HomeViewModel()
	
	@IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel.loadCompleteHandler = { [weak self] in
			self?.collectionView.reloadData()
		}
		
		if currentUser.role == "vendor" {
			viewModel.loadMyBiddedJobs()
		} else {
			viewModel.loadMyPostingJobs()
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		collectionView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "segueDetail" {
			let vc = segue.destination as! JobDetailViewController
			vc.setJob(job: viewModel.myJobs[(sender as! IndexPath).row])
		}
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionElementKindSectionHeader {
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
			                                                         withReuseIdentifier: HomeColletionHeaderCell.id,
			                                                         for: indexPath) as! HomeColletionHeaderCell
			header.setup(with: viewModel)
			return header
		}
		
		return UICollectionReusableView()
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.myJobs.count
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionPostCell.id, for: indexPath) as! HomeCollectionPostCell
		cell.setup(with: viewModel.myJobs[indexPath.row])
		
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		performSegue(withIdentifier: "segueDetail", sender: indexPath)
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: (collectionView.frame.size.width - 15)/2, height: (collectionView.frame.size.width - 15)/2)
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 3.0, left: 2.5, bottom: 3.0, right: 2.5)
	}
}
