//
//  NewsViewController.swift
//  Mojo
//
//  Created by NIKHILESH on 19/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController,ParserDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblNews: UITableView!
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        vc.newsId = arrNews[indexPath.row].News_ID
        vc.newsBO = arrNews[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        

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
                    self.tblNews.isHidden = false
                    self.tblNews.reloadData()
                }
                else
                {
                    self.tblNews.isHidden = true
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
                    self.tblNews.isHidden = false
                    self.tblNews.reloadData()
                }
                else
                {
                    self.tblNews.isHidden = true
                }
            }
        }

    }
}
