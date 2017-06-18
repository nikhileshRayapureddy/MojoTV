//
//  SplashViewController.swift
//  Mojo
//
//  Created by NIKHILESH on 22/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController,ParserDelegate {
    @IBOutlet weak var lblSlogan: UILabel!
    
    @IBOutlet weak var constLblSloganHeight: NSLayoutConstraint!
    var arrSlogans = [SloganBO]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let slogansData = UserDefaults.standard.object(forKey: "Slogans") as? NSData {
            arrSlogans = (NSKeyedUnarchiver.unarchiveObject(with: slogansData as Data) as? [SloganBO])!
        }
        
        if arrSlogans.count <= 0
        {
            self.getAllSlogans()
        }
        else
        {
            let index = 1 + arc4random() % 6
            let bo = arrSlogans[Int(index)-1] as SloganBO
            self.lblSlogan.text = bo.Slogan_Content
            constLblSloganHeight.constant = bo.Slogan_Content.heightWithConstrainedWidth(width: self.lblSlogan.frame.size.width, font: self.lblSlogan.font)
            
        }
        // Do any additional setup after loading the view.
        self.perform(#selector(navigateToNextScreen), with: nil, afterDelay: 2)
    }
    func randomNumber(range: Range<Int>) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }

    func navigateToNextScreen()
    {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    func getAllSlogans()
    {
        let Bl = BusinessLayer()
        Bl.callBack = self
        Bl.getAllSlogans()
    }
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        arrSlogans = object as! [SloganBO]
        let placesData = NSKeyedArchiver.archivedData(withRootObject:arrSlogans)
        Foundation.UserDefaults.standard.set(placesData, forKey: "Slogans")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
