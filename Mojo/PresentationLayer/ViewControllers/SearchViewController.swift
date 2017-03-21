//
//  SearchViewController.swift
//  Mojo
//
//  Created by NIKHILESH on 19/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ParserDelegate,UITextFieldDelegate {
    var arrNews = [NewsBO]()
    
    @IBOutlet weak var lblNoProducts: UILabel!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblSearch: UITableView!
    var strSearchTxt = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        txtFldSearch.becomeFirstResponder()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.view.endEditing(true)
      let _ = self.navigationController?.popViewController(animated: true)
    }
    //MARK: -textfield Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        strSearchTxt = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if strSearchTxt.characters.count <= 2
        {
            strSearchTxt = ""
            arrNews.removeAll()
        }
        
        if strSearchTxt.characters.count >= 3
        {
//            if app_delegate.isServerReachable == true
//            {
                self.performSelector(inBackground: #selector(self.getNewsWithKey(strKey:)), with:strSearchTxt)
//            }
//            else
//            {
//                self.showAlert(NO_INTERNET)
//            }
            
        }
        else
        {
            arrNews.removeAll()
            
        }
        self.tblSearch.reloadData()
        return true
        
    }
    //MARK: - Service Calls
    func getNewsWithKey(strKey : String)
    {
        app_delegate.showLoader(message: "")
        let BL = BusinessLayer()
        BL.callBack = self
        BL.getNewsWith(searchKey: strKey)
    }
    //MARK: - Parser Delegates
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        if tag == ParsingConstant.getSearchresults.rawValue
        {
            DispatchQueue.main.async {
                app_delegate.removeloder()
                self.bindAutoResults(object: object!)
            }
        }
    }
    func bindAutoResults(object : AnyObject)
    {
        self.arrNews = object as! [NewsBO]
        if arrNews.count == 0
        {
            self.tblSearch.isHidden = true
            lblNoProducts.isHidden = false
        }
        else
        {
            self.tblSearch.isHidden = false
            lblNoProducts.isHidden = true
        }
        
        self.tblSearch.reloadData()
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            if (textField.text?.characters.count)! > 0
            {
                self.getNewsWithKey(strKey: textField.text!)
            }
        return true
    }

    //MARK: - TableviewDelegates & Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "HomeCustomCell", for: indexPath) as! HomeCustomCell
        let bo = arrNews[indexPath.row]
        let strImage = "http://img.youtube.com/vi/" + bo.News_VideoLink + "/0.jpg"
        let url = URL(string:strImage)
        cell.imgVwNews.kf.setImage(with: url ,
                                   placeholder: UIImage(named: "no-image"),
                                   options: [.transition(ImageTransition.fade(1))],
                                   progressBlock: { receivedSize, totalSize in
                                    
        },
                                   completionHandler: { image, error, cacheType, imageURL in
                                    
        })
        cell.lblNews.text = bo.News_Subject
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        vc.newsId = arrNews[indexPath.row].News_ID
        vc.newsBO = arrNews[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
