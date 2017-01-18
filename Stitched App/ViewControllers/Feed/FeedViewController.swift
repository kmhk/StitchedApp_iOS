//
//  FeedViewController.swift
//  Stitched App
//
//  Created by Com on 18/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
	
	var viewModel = FeedViewModel()
	
	@IBOutlet weak var tableFeedView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		viewModel.loadCompleteHandler = { [weak self] in
			self?.tableFeedView.reloadData()
		}
		
		viewModel.loadJobs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		tableFeedView.reloadData()
	}

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "segueDetail" {
			let vc = segue.destination as! JobDetailViewController
			vc.job = viewModel.allJobs[(sender as! IndexPath).row]
		}
    }

}


extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.allJobs.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.id, for: indexPath) as! FeedTableViewCell
		cell.setup(with: viewModel.allJobs[indexPath.row])
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		performSegue(withIdentifier: "segueDetail", sender: indexPath)
	}
}
