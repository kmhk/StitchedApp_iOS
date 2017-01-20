//
//  TermsAndUseViewController.swift
//  Stitched App
//
//  Created by Com on 20/01/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class TermsAndUseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func BackBtnTap(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}

}
