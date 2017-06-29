//
//  SearchViewController.swift
//  Mojo
//
//  Created by NIKHILESH on 19/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ParserDelegate,UITextFieldDelegate {
    var arrNews = [NewsBO]()
    
    @IBOutlet weak var clVwSerach: UICollectionView!
    @IBOutlet weak var lblNoProducts: UILabel!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    var strSearchTxt = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName=UINib(nibName: "RelatedNewsCollectionViewCell", bundle:nil)
        clVwSerach.register(nibName, forCellWithReuseIdentifier: "RelatedNewsCollectionViewCell")

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
        self.clVwSerach.reloadData()
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
            self.clVwSerach.isHidden = true
            lblNoProducts.isHidden = false
        }
        else
        {
            self.clVwSerach.isHidden = false
            lblNoProducts.isHidden = true
        }
        
        self.clVwSerach.reloadData()
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            if (textField.text?.characters.count)! > 0
            {
                self.getNewsWithKey(strKey: textField.text!)
            }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNews.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedNewsCollectionViewCell", for: indexPath) as! RelatedNewsCollectionViewCell
        let bo = arrNews[indexPath.row]
        //        let strImage = "http://img.youtube.com/vi/" + bo.News_VideoLink + "/0.jpg"
        let correctedAddress = bo.News_Image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: correctedAddress!)
        cell.imgVw.kf.setImage(with: url ,
                               placeholder: UIImage(named: "no-image"),
                               options: [.transition(ImageTransition.fade(1))],
                               progressBlock: { receivedSize, totalSize in
                                
        },
                               completionHandler: { image, error, cacheType, imageURL in
                                print("error : \(error)")
                                if error != nil{
                                    let strImage = "http://img.youtube.com/vi/" + bo.News_VideoLink + "/0.jpg"
                                    let correctedAddress = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                    let url = URL(string: correctedAddress!)
                                    cell.imgVw.kf.setImage(with: url ,
                                                           placeholder: UIImage(named: "no-image"),
                                                           options: [.transition(ImageTransition.fade(1))],
                                                           progressBlock: { receivedSize, totalSize in
                                                            
                                    },
                                                           completionHandler: { image, error, cacheType, imageURL in
                                    })
                                    
                                }
        })
        cell.lblName.text = bo.News_Subject.uppercased()
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.timeZone = TimeZone(identifier: "UTC")
        let date = df.date(from: bo.News_Date)
        df.dateFormat = "dd MM yyyy"
        let now = Date()
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day]
        formatter.unitsStyle = .short
        let string = formatter.string(from: date!, to: now)!
        
        var dif = string.replacingOccurrences(of: " days", with: "")
        dif = dif.replacingOccurrences(of: " day", with: "")
        if Int(dif)! < 1
        {
            cell.lblDate.text = "Today"
        }
        else if Int(dif)! == 1
        {
            cell.lblDate.text = "Yesterday"
        }
        else if Int(dif)! <= 7
        {
            cell.lblDate.text = dif + " days ago"
        }
        else{
            cell.lblDate.text = bo.News_Date
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        vc.newsId = arrNews[indexPath.row].News_ID
        vc.newsBO = arrNews[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 15)/2, height: 150)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
