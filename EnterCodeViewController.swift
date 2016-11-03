//
//  EnterCodeViewController.swift
//  Verify
//
//  Created by aviledovsky on 01/11/2016.
//  Copyright © 2016 aviledovsky. All rights reserved.
//

import UIKit
import SinchVerification;

class EnterCodeViewController: UIViewController {
    var verification:Verification!;
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var pinCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad();
        pinCode.becomeFirstResponder();
    }
    
    @IBAction func verify(sender: AnyObject) {
        spinner.startAnimating();
        verifyButton.isEnabled = false;
        status.text  = "";
        pinCode.isEnabled = false;
        verification.verify(pinCode.text!, completion: { (success:Bool, error:Error?) -> Void in
            
            
            self.spinner.stopAnimating();
            self.verifyButton.isEnabled = true;
            self.pinCode.isEnabled = true;
            if (success) {
                self.status.text = "Verified";
            } else {
                self.status.text = error?.localizedDescription;
            }
        });
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

}
