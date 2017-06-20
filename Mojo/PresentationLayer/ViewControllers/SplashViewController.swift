//
//  SplashViewController.swift
//  Mojo
//
//  Created by NIKHILESH on 22/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController,ParserDelegate {
    
    @IBOutlet weak var imgVwLogo: UIImageView!
    var arrSlogans = [SloganBO]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1.0, animations: { 
            self.imgVwLogo.transform = CGAffineTransform(scaleX: 0.5,y: 0.5)

        }) { (finished) in
            UIView.animate(withDuration: 1.0, animations: {
                self.imgVwLogo.transform = CGAffineTransform(scaleX: 1.5,y: 1.5)
                
            }) { (finished) in
                self.imgVwLogo.isHidden = true
                
            }

        }

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
}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
