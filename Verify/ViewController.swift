//
//  ViewController.swift
//  Verify
//
//  Created by aviledovsky on 01/11/2016.
//  Copyright © 2016 aviledovsky. All rights reserved.
//

import UIKit
import SinchVerification


class ViewController: UIViewController {
    
    var verification:Verification!;
    var applicationKey = "7048348f-0843-436e-bcce-d8f5c4ef4311";

    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var calloutButton: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var spinner:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        phoneNumber.becomeFirstResponder();
        disableUI(false);
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    func disableUI(_ disable: Bool){
        var alpha:CGFloat = 1.0;
        if (disable) {
            alpha = 0.5;
            phoneNumber.resignFirstResponder();
            spinner.startAnimating();
            self.status.text="";
            let delayTime = DispatchTime.now() + Double(Int64(30 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { () -> Void in
                self.disableUI(false);
            });
        }
        else{
            self.phoneNumber.becomeFirstResponder();
            self.spinner.stopAnimating();
            
        }
        self.phoneNumber.isEnabled = !disable;
        self.smsButton.isEnabled = !disable;
        self.calloutButton.isEnabled = !disable;
        self.calloutButton.alpha = alpha;
        self.smsButton.alpha = alpha;
    }
    
    @IBAction func smsVerification(_ sender: AnyObject) {
        self.disableUI(true);
        verification = SMSVerification(applicationKey, phoneNumber: phoneNumber.text!)
        verification.initiate { (<#InitiationResult#> , <#Error?#>) in
            self.disableUI(false);
            if (success){
                self.performSegue(withIdentifier: "enterPin", sender: sender)
                
            } else {
                
                self.status.text = error?.localizedDescription
            }
        }
    }
    @IBAction func calloutVerification(_ sender: AnyObject) {
        disableUI(true);
        verification = CalloutVerification(applicationKey, phoneNumber: phoneNumber.text!);
        verification.initiate { (success:Bool, error:Error?) -> Void in
            self.disableUI(false);
            self.status.text = (success ? "Verified" : error?.localizedDescription);
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "enterPin") {
            let enterCodeVC = segue.destination as! EnterCodeViewController;
            enterCodeVC.verification = self.verification;
        }
        
    }
}
