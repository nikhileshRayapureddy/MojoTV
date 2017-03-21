//
//  BaseViewController.swift
//  UrDoorStep
//
//  Created by Nikhilesh on 12/10/16.
//  Copyright © 2016 Capillary. All rights reserved.
//

import UIKit
let Color_NavBarTint : UIColor =  UIColor(red: 158.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1)
let TAG_BOTTOM_BAR:Int = 1800

class BaseViewController: UIViewController {
    let lblCartCount = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func designNavBar(IsBack : Bool,isLogo:Bool,strTitle:String)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = Color_NavBarTint
        UINavigationBar.appearance().barTintColor = UIColor.black
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15
        if IsBack
        {
            let btnBack = UIButton(type: UIButtonType.custom)
            btnBack.frame = CGRect(x: -2, y: 0  , width: 44 , height: 44)
            btnBack.setImage(UIImage(named: "back"), for: UIControlState.normal)
            btnBack.addTarget(self, action: #selector(self.btnBackClicked(sender:)), for: UIControlEvents.touchUpInside)
            let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
            self.navigationItem.leftBarButtonItems = [negativeSpacer, leftBarButtonItem]
        }
        else
        {
            let menuButton = UIButton(type: UIButtonType.custom)
            menuButton.frame = CGRect(x: -2, y: 0  , width: 44 , height: 44)
            menuButton.setImage(UIImage(named: "menu"), for: UIControlState.normal)
            menuButton.addTarget(self, action: #selector(self.menuClicked(sender:)), for: UIControlEvents.touchUpInside)
            let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
            self.navigationItem.leftBarButtonItems = [negativeSpacer, leftBarButtonItem]
            
        }
        if isLogo
        {
            let logoImgView = UIButton(type: UIButtonType.custom)
            logoImgView.frame =  CGRect(x: 0, y: 0, width: 100, height: 35)
            logoImgView.setImage(UIImage(named:"Logo_NavBar"), for: .normal)
            logoImgView.setImage(UIImage(named:"Logo_NavBar"), for: .selected)
            logoImgView.setImage(UIImage(named:"Logo_NavBar"), for: .highlighted)
            logoImgView.titleLabel?.font = UIFont (name: "pt-sans.bold", size: 20)
            
            self.navigationItem.titleView = logoImgView

        }
        else
        {
            let logoImgView = UIButton(type: UIButtonType.custom)
            logoImgView.frame =  CGRect(x: 0, y: 0, width: 100, height: 35)
            logoImgView.setTitle(strTitle, for: .normal)
            logoImgView.setTitleColor(UIColor.white, for: .normal)
            logoImgView.titleLabel?.font = UIFont (name: "pt-sans.bold", size: 20)
            
            self.navigationItem.titleView = logoImgView

        }
        
        
        
    }
    func designNavBarForHome()
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = Color_NavBarTint
        UINavigationBar.appearance().barTintColor = UIColor.black
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15
        let menuButton = UIButton(type: UIButtonType.custom)
        menuButton.frame = CGRect(x: -2, y: 0  , width: 44 , height: 44)
        menuButton.setImage(UIImage(named: "menu"), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(self.menuClicked(sender:)), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.leftBarButtonItems = [negativeSpacer, leftBarButtonItem]
        let logoImgView = UIButton(type: UIButtonType.custom)
        logoImgView.frame =  CGRect(x: 0, y: 0, width: 100, height: 35)
        logoImgView.setImage(UIImage(named:"Logo_NavBar"), for: .normal)
        logoImgView.setImage(UIImage(named:"Logo_NavBar"), for: .selected)
        logoImgView.setImage(UIImage(named:"Logo_NavBar"), for: .highlighted)
        logoImgView.contentMode = .left
        logoImgView.titleLabel?.font = UIFont (name: "pt-sans.bold", size: 20)
        
        self.navigationItem.titleView = logoImgView
        
        let btnsearch = UIButton(type: UIButtonType.custom)
        btnsearch.frame = CGRect(x: -2, y: 0  , width: 44 , height: 44)
        btnsearch.setImage(UIImage(named: "search"), for: UIControlState.normal)
        btnsearch.addTarget(self, action: #selector(self.btnsearchClicked(sender:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: btnsearch)
        self.navigationItem.rightBarButtonItems = [negativeSpacer, rightBarButtonItem]

    }
    func btnsearchClicked( sender:UIButton)
    {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(vc, animated: false)

    }

    
    func menuClicked( sender:UIButton)
    {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    func btnBackClicked( sender:UIButton)
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
}
