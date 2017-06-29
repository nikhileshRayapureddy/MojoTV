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
class HomeViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,ParserDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout {
    let TagBannerDetail = 1000
    @IBOutlet weak var scrlVwFlashNews: UIScrollView!
    @IBOutlet weak var scrlVwBanner: UIScrollView!
    @IBOutlet weak var pageControlBanner: UIPageControl!
    @IBOutlet weak var constPageCtrlWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btnTrending: UIButton!
    
    @IBOutlet weak var btnEditor: UIButton!
    
    @IBOutlet weak var btnTop10: UIButton!
    
    @IBOutlet weak var btnWeird: UIButton!
    var timer : Timer!
    var timer1 : Timer!
    var catCount = 0
    var arrBanners = [BannerBO]()
    var arrCategories = [CategoriesBO]()
    var isFromSideMenu = false
    var isFeedback = false
    var isTerms = false
    var isAboutUS = false
    var arrFlashNews = [FlashNewsBO]()
    @IBOutlet weak var clVwHome: UICollectionView!
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
        let nibName=UINib(nibName: "RelatedNewsCollectionViewCell", bundle:nil)
        clVwHome.register(nibName, forCellWithReuseIdentifier: "RelatedNewsCollectionViewCell")
        let nibReusable=UINib(nibName: "CollectionReusableView", bundle:nil)
        clVwHome.register(nibReusable, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ReusableView")

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
        if timer1 != nil
        {
            timer1.invalidate()
            timer1 = nil
            
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
    //MARK: - Collectionview Delegates & Datasources
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategories[section].arrNews.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedNewsCollectionViewCell", for: indexPath) as! RelatedNewsCollectionViewCell
        let bo = arrCategories[indexPath.section].arrNews[indexPath.row]
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
        df.dateFormat = "dd MMM yyyy"
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

            cell.lblDate.text = df.string(from: date!)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        vc.newsId = arrCategories[indexPath.section].arrNews[indexPath.row].News_ID
        vc.newsBO = arrCategories[indexPath.section].arrNews[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview : CollectionReusableView!
            if kind == UICollectionElementKindSectionHeader
            {
             var headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ReusableView", for: indexPath) as? CollectionReusableView
                if headerView == nil{
                    headerView = Bundle.main.loadNibNamed("CollectionReusableView", owner: nil, options: nil)?[0] as? CollectionReusableView
                }
                headerView?.lblHeader.text = arrCategories[indexPath.section].Category_Name

                reusableview = headerView!
        }
        return reusableview
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width, height: 35)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 15)/2, height: 150)
    }
    //MARK: - Service calls
    func getAllFlashNews()
    {
        let BL = BusinessLayer()
        BL.callBack = self
        BL.getAllFlashNews()

    }
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
            
            self.getAllFlashNews()

        }
        else if tag == ParsingConstant.getAllFlashNews.rawValue
        {
            arrFlashNews.removeAll()
            arrFlashNews = object as! [FlashNewsBO]
            DispatchQueue.main.async {
                self.bindFlashNews()
            }
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
                    self.clVwHome.reloadData()
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
    func bindFlashNews()
    {
        scrlVwFlashNews.contentSize = CGSize(width: CGFloat(arrFlashNews.count) * ScreenWidth, height: scrlVwFlashNews.frame.size.height)
        
        var x : CGFloat = 0
        
        for i in 0..<arrFlashNews.count
        {
            let bo = arrFlashNews[i]
            
            let lblFlashNews = UILabel(frame: CGRect(x: x, y: 0, width: scrlVwFlashNews.frame.size.width, height: scrlVwFlashNews.frame.size.height))
            lblFlashNews.numberOfLines = 2
            lblFlashNews.lineBreakMode = .byWordWrapping
            lblFlashNews.text = bo.FlashNews_Content
            lblFlashNews.textAlignment = .center
            lblFlashNews.font = UIFont(name: "Helvetica-Bold", size: 15)
            lblFlashNews.textColor = UIColor.white
            scrlVwFlashNews.addSubview(lblFlashNews)
            
            x += scrlVwFlashNews.frame.size.width
        }
        if timer1 == nil
        {
            timer1 = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.scrollFlashNews), userInfo: nil, repeats: true)
        }
        
        
    }
    func scrollFlashNews()
    {
        let contentOffset : CGFloat = (scrlVwFlashNews.contentOffset.x)
        
        let nextPage : Int = Int((contentOffset/ScreenWidth) + 1)
        
        if nextPage != arrFlashNews.count
        {
            scrlVwFlashNews.setContentOffset(CGPoint(x: CGFloat(nextPage) * ScreenWidth, y: 0), animated: true)
        }
        else
        {
            scrlVwFlashNews.setContentOffset(CGPoint.zero, animated: true)
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
            let correctedAddress = bo.News_Image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: correctedAddress!)
//            let strImage = "http://img.youtube.com/vi/" + bo.News_VideoLink + "/0.jpg"
//            let url = URL(string:strImage)
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

