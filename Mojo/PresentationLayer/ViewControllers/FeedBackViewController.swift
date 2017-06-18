//
//  FeedBackViewController.swift
//  ViralMojo
//
//  Created by Nikhilesh on 21/03/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class FeedBackViewController: BaseViewController,ParserDelegate {

    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtVwComments: UITextView!
    var rating = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBar(IsBack: true, isLogo:false, strTitle: "Feedback")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRatingClicked(_ sender: UIButton) {
        for i in 1..<6
        {
            let btn = sender.superview?.viewWithTag(500 + i) as! UIButton
            btn.isSelected = false
        }
        for i in 1...sender.tag - 500
        {
            let btn = sender.superview?.viewWithTag(500 + i) as! UIButton
            btn.isSelected = true
        }
        rating = "\(sender.tag - 500)"
    }

    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        if txtFldEmail.text == ""
        {
            self.showAlertWithMessage(strMsg: "Please enter your Mail-Id.")
        }
        else if txtVwComments.text == ""
        {
            self.showAlertWithMessage(strMsg: "Please enter your comments.")
        }
        else if rating == ""
        {
            self.showAlertWithMessage(strMsg: "Please select rating.")
        }
        else if isValidEmail(testStr: txtFldEmail.text!) == false
        {
            self.showAlertWithMessage(strMsg: "Please enter valid Mail-Id.")
        }
        else
        {
            self.callFeedBackService()
        }
    }
    func callFeedBackService() {
        app_delegate.showLoader(message: "")
        let BL = BusinessLayer()
        BL.callBack = self
        BL.setFeedbackWith(emailId: txtFldEmail.text!, rating: rating, comments: txtVwComments.text!)
    }
    
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        DispatchQueue.main.async {
            self.showAlertWithMessage(strMsg: "Unable to send your Feedback.")
        }
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        DispatchQueue.main.async {

        let alertController = UIAlertController(title: "Success!", message: "Your Feedback has been successfully submitted.", preferredStyle: .alert)
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            DispatchQueue.main.async {
              let _ =  self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithMessage(strMsg : String)
    {
        let alertController = UIAlertController(title: "Alert!", message: strMsg, preferredStyle: .alert)
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
        }
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
