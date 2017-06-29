//
//  NewsViewController.swift
//  Mojo
//
//  Created by NIKHILESH on 19/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController,ParserDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var clVwNews: UICollectionView!
    var arrNews = [NewsBO]()
    var catID = ""
    var catName = ""
    var isFromTopNews = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBar(IsBack: true,isLogo: false,strTitle: catName)
        if isFromTopNews == true
        {
            self.getTopNews()
        }
        else
        {
            self.getcategoriesWith(ID: catID)
        }
        let nibName=UINib(nibName: "RelatedNewsCollectionViewCell", bundle:nil)
        clVwNews.register(nibName, forCellWithReuseIdentifier: "RelatedNewsCollectionViewCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        if bo.News_Short_Subject == ""
        {
            cell.lblName.text = bo.News_Subject.uppercased()
        }
        else
        {
            cell.lblName.text = bo.News_Short_Subject.uppercased()
        }
        
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

    func getcategoriesWith(ID : String)
    {
        app_delegate.showLoader(message: "")
        let BL = BusinessLayer()
        BL.callBack = self
        BL.getNewsByCategoryWith(ID: ID)
    }
    func getTopNews()
    {
        app_delegate.showLoader(message: "")
        let BL = BusinessLayer()
        BL.callBack = self
        BL.getTopNewsWith(ID: catID)
    }

    //MARK: - Parser Delegates
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        if tag == ParsingConstant.getAllNews.rawValue
        {
            DispatchQueue.main.async {
                    app_delegate.removeloder()
                self.arrNews.removeAll()
                    self.arrNews = object as! [NewsBO]
                if self.arrNews.count > 0
                {
                    self.clVwNews.isHidden = false
                    self.clVwNews.reloadData()
                }
                else
                {
                    self.clVwNews.isHidden = true
                }
            }
        }
        else if tag == ParsingConstant.getTopNews.rawValue
        {
            DispatchQueue.main.async {
                app_delegate.removeloder()
                self.arrNews.removeAll()
                self.arrNews = object as! [NewsBO]
                if self.arrNews.count > 0
                {
                    self.clVwNews.isHidden = false
                    self.clVwNews.reloadData()
                }
                else
                {
                    self.clVwNews.isHidden = true
                }
            }
        }

    }
}
