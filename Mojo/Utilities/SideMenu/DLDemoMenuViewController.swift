//
//  DLDemoMenuViewController.swift
//  DLHamburguerMenu
//
//  Created by Nacho on 5/3/15.
//  Copyright (c) 2015 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

class DLDemoMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    // data
    var arrConstantLabels = ["About Us","Terms Conditions","Feedback"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate&DataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return arrAllCategories.count
        }
        else
        {
            return arrConstantLabels.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell : MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)  as! MenuCell
            cell.backgroundColor = UIColor.clear
        if indexPath.section == 0
        {
            cell.lblTitle.text = arrAllCategories[indexPath.row].Category_Name
            cell.lblTitle.textColor = UIColor.black
            if indexPath.row == arrAllCategories.count - 1
            {
                cell.imgSep.isHidden = false
            }
            else
            {
                cell.imgSep.isHidden = true
            }
        }
        else
        {
            cell.imgSep.isHidden = true
            cell.lblTitle.text = arrConstantLabels[indexPath.row]
            cell.lblTitle.textColor = UIColor.lightGray
        }
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0
        {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.isFromSideMenu = true
        vc.catID = arrAllCategories[indexPath.row].Category_ID
        vc.catName = arrAllCategories[indexPath.row].Category_Name
        let navVC = UINavigationController.init(rootViewController: vc)
        if let hamburguerViewController = self.findHamburguerViewController() {
            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                
                hamburguerViewController.contentViewController = navVC
            })
        }
        }
        else
        {
            
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            if indexPath.row == 0
            {
                vc.isAboutUS = true
            }
            else if indexPath.row == 1
            {
                vc.isTerms = true
            }
            else if indexPath.row == 2
            {
                vc.isFeedback = true
            }
            else
            {
                vc.isFromSideMenu = false
            }
            let navVC = UINavigationController.init(rootViewController: vc)
            if let hamburguerViewController = self.findHamburguerViewController() {
                hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                    
                    hamburguerViewController.contentViewController = navVC
                })
            }
            
        }
    }
    
    // MARK: - Navigation
    
    func mainNavigationController() -> DLHamburguerNavigationController {
        return self.storyboard?.instantiateViewController(withIdentifier: "DLDemoNavigationViewController") as! DLHamburguerNavigationController
    }
    

}
