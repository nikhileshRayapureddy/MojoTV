//
//  NewsDetailViewController.swift
//  Mojo
//
//  Created by NIKHILESH on 19/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class NewsDetailViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,ParserDelegate,YTPlayerViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var vwVideoPlayer: YTPlayerView!
    @IBOutlet weak var clVwRelatedNews: UICollectionView!
    var newsId = ""
    var newsBO = NewsBO()
    
    @IBOutlet weak var constVwLblHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblNewName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBar(IsBack: true,isLogo: true,strTitle: "")
        // Do any additional setup after loading the view.
        let nibName=UINib(nibName: "RelatedNewsCollectionViewCell", bundle:nil)
        clVwRelatedNews.register(nibName, forCellWithReuseIdentifier: "RelatedNewsCollectionViewCell")
        self.getSingleNews()

    }
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState)
    {
//        if state == .playing
//        {
//            let value = UIInterfaceOrientation.landscapeLeft.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }
    }
    func enteredFullScreen (sender:NSNotification)
    {
        print("enteredFullScreen")
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    func exitedFullScreen (sender:NSNotification)
    {
        print("exitedFullScreen")
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    //MARK: - Collectionview Delegates & Datasources
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsBO.arrRelatedNews.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedNewsCollectionViewCell", for: indexPath) as! RelatedNewsCollectionViewCell
        let bo = newsBO.arrRelatedNews[indexPath.row]
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
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 15)/2, height: 135)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newsBO = newsBO.arrRelatedNews[indexPath.row]
        newsId = newsBO.News_ID
        self.getSingleNews()
    }
    //MARK : - Service Calls
    func getSingleNews()
    {
        app_delegate.showLoader(message: "")
        let BL = BusinessLayer()
        BL.callBack = self
        BL.getNewsWith(ID: newsId)
    }
    func checkLike()
    {
        let BL = BusinessLayer()
        BL.callBack = self
        BL.checkLikeFor(newsID:newsId)
    }

    func parsingError(_ error: String?, withTag tag: NSInteger) {
        app_delegate.removeloder()
        if tag == ParsingConstant.setLike.rawValue
        {
            print("Failed to like the video")
            DispatchQueue.main.async {
                self.btnLike.isSelected = false
            }
        }
        else if tag == ParsingConstant.checkLike.rawValue
        {
            DispatchQueue.main.async {
                self.btnLike.isSelected = false
            }
        }

    }
    func parsingFinished(_ object: AnyObject?, withTag tag: NSInteger) {
        if tag == ParsingConstant.getNews.rawValue
        {
            DispatchQueue.main.async {
                self.newsBO = object as! NewsBO
                //let playerVars = ["playsinline":1]
                let playerVars = ["playsinline":1, "controls" : 1, "autohide" : 1, "showinfo" : 1, "autoplay" : 1, "fs" : 1, "rel" : 0, "loop" : 0, "enablejsapi" : 1,"modestbranding" : 1] as [String : Any]
                
                self.vwVideoPlayer.load(withVideoId: self.newsBO.News_VideoLink, playerVars: playerVars)
                self.vwVideoPlayer.delegate = self
                NotificationCenter.default.addObserver(self, selector: #selector(self.enteredFullScreen(sender:)), name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.exitedFullScreen(sender:)), name: NSNotification.Name.UIWindowDidBecomeHidden, object: nil)
                self.clVwRelatedNews.reloadData()
                self.lblNewName.text = self.newsBO.News_Subject
                
                self.constVwLblHeight.constant = self.getHeightforController(view: self.lblNewName, width: self.lblNewName.frame.size.width)
                self.lblLikes.text = self.newsBO.News_Likes
                self.checkLike()
            }
        }
        else if tag == ParsingConstant.setLike.rawValue
        {
            app_delegate.removeloder()
            DispatchQueue.main.async {
                self.btnLike.isSelected = true
                let count = Int(self.lblLikes.text!)
                self.lblLikes.text = "\(count! + 1)"

            }
        }
        else if tag == ParsingConstant.checkLike.rawValue
        {
            app_delegate.removeloder()

            DispatchQueue.main.async {
                self.btnLike.isSelected = true
                let count = Int(self.lblLikes.text!)
                self.lblLikes.text = "\(count! + 1)"

            }
        }
        else
        {
            app_delegate.removeloder()
        }

    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView)
    {
        self.vwVideoPlayer.playVideo()
    }

    @IBAction func btnShareClicked(_ sender: UIButton) {
        
        let vc = UIActivityViewController(activityItems: ["https://www.youtube.com/watch?v=" + self.newsBO.News_VideoLink], applicationActivities: [])
        present(vc, animated: true)
    }
    
    @IBAction func btnlikeClicked(_ sender: UIButton) {
        if sender.isSelected == false
        {
            self.setLikes()
        }
    }
    func setLikes()
    {
        app_delegate.showLoader(message: "")
        let BL = BusinessLayer()
        BL.callBack = self
        BL.setLikeFor(newsId: self.newsBO.News_ID)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vwVideoPlayer.stopVideo()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getHeightforController(view: AnyObject,width : CGFloat) -> CGFloat {
        let tempView: UILabel = view as! UILabel
        let context: NSStringDrawingContext = NSStringDrawingContext()
        context.minimumScaleFactor = 0.8
        
        let size: CGSize = tempView.text!.boundingRect(with: CGSize(width: width, height: 2000), options:NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: tempView.font], context: context).size as CGSize
        if size.height >= 43
        {
            return size.height
        }
        else
        {
            return 43
        }
    }
}
