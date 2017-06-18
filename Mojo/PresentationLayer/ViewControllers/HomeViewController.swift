//
//  ViewController.swift
//  Mojo
//
//  Created by NIKHILESH on 18/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit
let strBannerImage = ""
var arrAllCategories = [CategoriesBO]()

let COLOR_GREEN = UIColor(red: 0.0/255.0, green: 136.0/255.0, blue: 225.0/255.0, alpha: 1)
class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,ParserDelegate,UIScrollViewDelegate {
    let TagBannerDetail = 1000
    @IBOutlet weak var scrlVwBanner: UIScrollView!
    @IBOutlet weak var tblVwHome: UITableView!
    @IBOutlet weak var pageControlBanner: UIPageControl!
    @IBOutlet weak var constPageCtrlWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btnTrending: UIButton!
    
    @IBOutlet weak var btnEditor: UIButton!
    
    @IBOutlet weak var btnTop10: UIButton!
    
    @IBOutlet weak var btnWeird: UIButton!
    var timer : Timer!
    var catCount = 0
    var arrBanners = [BannerBO]()
    var arrCategories = [CategoriesBO]()
    var isFromSideMenu = false
    var isFeedback = false
    var isTerms = false
    var isAboutUS = false

    var catID = ""
    var catName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if isFromSideMenu
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
            vc.catID = catID
            vc.catName = catName
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else if isFeedback
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else if isTerms
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TandCViewController") as! TandCViewController
            self.navigationController?.pushViewController(vc, animated: false)

        }
        else if isAboutUS
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            self.navigationController?.pushViewController(vc, animated: false)

        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            catCount = 0
            self.designNavBarForHome()
            self.getAllBanners()
            self.getAllcategories()
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if timer != nil
        {
            timer.invalidate()
            timer = nil
            
        }
    }

    @IBAction func btnTrendingClicked(_ sender: UIButton) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        vc.catID = "toptrends"
        vc.catName = "TRENDING"
        vc.isFromTopNews = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEditorClicked(_ sender: UIButton) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        vc.catID = "editorpic"
        vc.catName = "EDITOR'S PIC"
        vc.isFromTopNews = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func btnTop10Clicked(_ sender: UIButton) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        vc.catID = "exclusive"
        vc.catName = "TOP 10"
        vc.isFromTopNews = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnWeirdClicked(_ sender: UIButton) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        vc.catID = "weiredworld"
        vc.catName = "WEIRD WORLD"
        vc.isFromTopNews = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
    }
    //MARK: - TableviewDelegates & Datasources
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCategories.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategories[section].arrNews.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "HomeCustomCell", for: indexPath) as! HomeCustomCell
        let bo = arrCategories[indexPath.section].arrNews[indexPath.row]
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
        vc.newsId = arrCategories[indexPath.section].arrNews[indexPath.row].News_ID
        vc.newsBO = arrCategories[indexPath.section].arrNews[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        vw.backgroundColor = COLOR_GREEN
        
        let lblHeader = UILabel(frame: CGRect(x: 10, y: 0, width: vw.frame.size.width, height: vw.frame.size.height))
        lblHeader.backgroundColor = UIColor.clear
        lblHeader.textColor = UIColor.white
        lblHeader.text = arrCategories[section].Category_Name
        vw.addSubview(lblHeader)
        return vw
    }
    //MARK: - Service calls
    func getAllBanners()
    {
        app_delegate.showLoader(message: "")
        let BL = BusinessLayer()
        BL.callBack = self
        BL.getAllBanners()
    }
    func getAllcategories()
    {
        app_delegate.showLoader(message: "")
        let BL = BusinessLayer()
        BL.callBack = self
        BL.getAllCategories()
    }
    func getcategoriesWith(ID : String)
    {
        app_delegate.showLoader(message: "")
        let BL = BusinessLayer()
        BL.callBack = self
        BL.getNewsByCategoryWith(ID: ID)
    }
    func getAllNews()
    {
        let category = arrAllCategories[catCount]
        self.getcategoriesWith(ID: category.Category_ID)
    }
//MARK: - Parser Delegates
    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        
    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        if ParsingConstant.getBanners.rawValue == tag
        {
            app_delegate.removeloder()
            arrBanners = (object as? [BannerBO])!
            self.performSelector(onMainThread: #selector(self.bindAllBanners), with: nil, waitUntilDone: true)
        }
        else if tag == ParsingConstant.getCategories.rawValue
        {
            arrCategories.removeAll()
            arrAllCategories.removeAll()
            arrAllCategories = (object as? [CategoriesBO])!
            self.getAllNews()

        }
        else if tag == ParsingConstant.getAllNews.rawValue
        {
            DispatchQueue.main.async {
                self.insertData(obj: object!)
                self.catCount = self.catCount + 1
                print("catCount : \(self.catCount)")
                if self.catCount == arrAllCategories.count - 1
                {
                    for cat in arrAllCategories
                    {
                        if cat.arrNews.count > 0
                        {
                            self.arrCategories.append(cat)
                        }
                    }
                    app_delegate.removeloder()
                    self.tblVwHome.reloadData()
                }
                else
                {
                    self.getAllNews()
                    
                }
            }
        }
    }
    func insertData(obj : AnyObject)
    {
        let arr = obj as? [NewsBO]
        if (arr?.count)! > 0
        {
            arrAllCategories[catCount].arrNews = arr!
            
        }
    }

    func bindAllBanners()
    {
        pageControlBanner.numberOfPages = arrBanners.count
        constPageCtrlWidth.constant = CGFloat(pageControlBanner.numberOfPages*16);
        scrlVwBanner.contentSize = CGSize(width: CGFloat(arrBanners.count) * ScreenWidth, height: scrlVwBanner.frame.size.height)
        
        var x : CGFloat = 0
        
        for i in 0..<arrBanners.count
        {
            let bo = arrBanners[i] 
            
            let imgBanners = UIImageView(frame: CGRect(x: x, y: 0, width: scrlVwBanner.frame.size.width, height:scrlVwBanner.frame.size.height))
            imgBanners.isUserInteractionEnabled = true
            let strImage = "http://img.youtube.com/vi/" + bo.News_VideoLink + "/0.jpg"
            let url = URL(string:strImage)
            imgBanners.kf.setImage(with: url ,
                                   placeholder: UIImage(named: "no-image"),
                                   options: [.transition(ImageTransition.fade(1))],
                                   progressBlock: { receivedSize, totalSize in
                                    
            },
                                   completionHandler: { image, error, cacheType, imageURL in
                                    
            })
            scrlVwBanner.addSubview(imgBanners)
            imgBanners.contentMode = .scaleToFill
            //Banner Detail Button...
            let  bannerDetailButton =  UIButton( type: .custom)
            bannerDetailButton.frame = imgBanners.frame
            
            
            scrlVwBanner.isUserInteractionEnabled = true
            scrlVwBanner.addSubview(bannerDetailButton)
            bannerDetailButton.tag = TagBannerDetail + i
            scrlVwBanner.bringSubview(toFront: bannerDetailButton)
            
            bannerDetailButton.addTarget(self, action: #selector(self.btnBannerDetailClicked(sender:)), for: .touchUpInside)
            
            x += scrlVwBanner.frame.size.width
        }
        if timer == nil
        {
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.scrollingTimer), userInfo: nil, repeats: true)
        }

        
    }
    func scrollingTimer()
    {
        let contentOffset : CGFloat = (scrlVwBanner.contentOffset.x)
        
        let nextPage : Int = Int((contentOffset/ScreenWidth) + 1)
        
        if nextPage != arrBanners.count
        {
            scrlVwBanner.setContentOffset(CGPoint(x: CGFloat(nextPage) * ScreenWidth, y: 0), animated: true)
        }
        else
        {
            scrlVwBanner.setContentOffset(CGPoint.zero, animated: true)
        }
        pageControlBanner.currentPage = nextPage

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let  pageNo = round(scrlVwBanner.contentOffset.x / scrlVwBanner.frame.size.width) as CGFloat
        pageControlBanner.currentPage = Int(pageNo)

    }
    func btnBannerDetailClicked(sender : UIButton)
    {
        let bo = arrBanners[sender.tag - TagBannerDetail]

        let newsBO = NewsBO()
        newsBO.News_ID = bo.News_ID
        newsBO.Category = bo.Category
        newsBO.Category_ID = bo.Category_ID
        newsBO.News_Subject = bo.News_Subject
        newsBO.News_VideoLink = bo.News_VideoLink
        newsBO.News_Likes = bo.News_Likes
        newsBO.News_Dislikes = bo.News_Dislikes
        newsBO.IsBreakingNews = bo.IsBreakingNews
        newsBO.News_Date = bo.News_Date
        
        
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        vc.newsId = newsBO.News_ID
        vc.newsBO = newsBO
        self.navigationController?.pushViewController(vc, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

