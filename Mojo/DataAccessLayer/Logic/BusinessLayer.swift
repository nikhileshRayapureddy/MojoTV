//
//  BusinessLayer.swift
//  UrDoorStep
//
//  Created by Nikhilesh on 26/09/16.
//  Copyright © 2016 Capillary. All rights reserved.
//

import UIKit
let NO_INTERNET = "No Internet Access. Check your network and try again."



let SERVER_ERROR = "Server not responding.\nPlease try after some time."

let CONTENT_LENGTH = "Content-Length"
let CONTENT_TYPE  = "Content-Type"


var shoppingListSelected : Int = 0

let app_delegate =  UIApplication.shared.delegate as! AppDelegate

let NoInternet : NSString = "There seems to be some data connectivity issue with your network. Please check connection and try again."
let ScreenWidth : CGFloat =  UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.height

let developer_API = "http://omnisoft.in/NewsAppServices/"
class BusinessLayer: BaseBL {
    func getAllBanners()
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getBanners.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "getBanners.php"
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let arrData  = obj.parsedDataDict["news"] as? [[String:AnyObject]]
                {
                    var arrBanner = [BannerBO]()
                    if arrData.count > 0
                    {
                        for dictData in arrData
                        {
                            let content = BannerBO()
                            if let News_ID = dictData["News_ID"] as? String
                            {
                                content.News_ID = News_ID
                            }
                            if let Category = dictData["Category"] as? String
                            {
                                content.Category = Category
                            }
                            if let Category_ID = dictData["Category_ID"] as? String
                            {
                                content.Category_ID = Category_ID
                            }
                            if let News_Subject = dictData["News_Subject"] as? String
                            {
                                content.News_Subject = News_Subject
                            }
                            if let News_VideoLink = dictData["News_VideoLink"] as? String
                            {
                                content.News_VideoLink = News_VideoLink
                            }
                            if let News_Image = dictData["News_Image"] as? String
                            {
                                content.News_Image = News_Image
                            }
                            if let News_Likes = dictData["News_Likes"] as? String
                            {
                                content.News_Likes = News_Likes
                            }
                            if let News_Dislikes = dictData["News_Dislikes"] as? String
                            {
                                content.News_Dislikes = News_Dislikes
                            }
                            if let IsBreakingNews = dictData["IsBreakingNews"] as? String
                            {
                                content.IsBreakingNews = IsBreakingNews
                            }
                            if let News_Date = dictData["News_Date"] as? String
                            {
                                content.News_Date = News_Date
                            }
                            arrBanner.append(content)
                        }
                    }
                    self.callBack?.parsingFinished(arrBanner as AnyObject?, withTag: obj.tag)
                }
                else
                {
                    self.callBack?.parsingError("No News Found.", withTag: obj.tag)

                }
            }
        }
        
    }
    func getAllCategories()
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getCategories.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "get_categories.php"
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let arrData  = obj.parsedDataDict["all_categories"] as? [[String:AnyObject]]
                {
                    var arrCategories = [CategoriesBO]()
                    if arrData.count > 0
                    {
                        for dictData in arrData
                        {
                            let content = CategoriesBO()
                            if let Category_ID = dictData["Category_ID"] as? String
                            {
                                content.Category_ID = Category_ID
                            }
                            if let Category_Name = dictData["Category_Name"] as? String
                            {
                                content.Category_Name = Category_Name
                            }
                            if let Category_Date = dictData["Category_Date"] as? String
                            {
                                content.Category_Date = Category_Date
                            }
                            if let Category_Order = dictData["Category_Order"] as? String
                            {
                                content.Category_Order = Category_Order
                            }

                            arrCategories.append(content)
                        }
                        //sorting based on 'Category_Order'  
                        arrCategories.sort{$0.Category_Order < $1.Category_Order}

                    }
                    self.callBack?.parsingFinished(arrCategories as AnyObject?, withTag: obj.tag)
                }
                else
                {
                    self.callBack?.parsingError("No News Found.", withTag: obj.tag)
                    
                }
            }
        }
        
    }
    func getNewsByCategoryWith(ID : String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getAllNews.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "getNews.php?categoryId=" + ID
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let isSuccess  = obj.parsedDataDict["success"] as? NSNumber
                {
                    if Bool(isSuccess) == true
                    {
                        if let arrData  = obj.parsedDataDict["news"] as? [[String:AnyObject]]
                        {
                            var arrNews = [NewsBO]()
                            if arrData.count > 0
                            {
                                for dictData in arrData
                                {
                                    let content = NewsBO()
                                    if let News_ID = dictData["News_ID"] as? String
                                    {
                                        content.News_ID = News_ID
                                    }
                                    if let Category = dictData["Category"] as? String
                                    {
                                        content.Category = Category
                                    }
                                    if let Category_ID = dictData["Category_ID"] as? String
                                    {
                                        content.Category_ID = Category_ID
                                    }
                                    if let News_Subject = dictData["News_Subject"] as? String
                                    {
                                        content.News_Subject = News_Subject
                                    }
                                    if let News_VideoLink = dictData["News_VideoLink"] as? String
                                    {
                                        content.News_VideoLink = News_VideoLink
                                    }
                                    if let News_Likes = dictData["News_Likes"] as? String
                                    {
                                        content.News_Likes = News_Likes
                                    }
                                    if let News_Dislikes = dictData["News_Dislikes"] as? String
                                    {
                                        content.News_Dislikes = News_Dislikes
                                    }
                                    if let IsBreakingNews = dictData["IsBreakingNews"] as? String
                                    {
                                        content.IsBreakingNews = IsBreakingNews
                                    }
                                    if let News_Date = dictData["News_Date"] as? String
                                    {
                                        content.News_Date = News_Date
                                    }
                                    arrNews.append(content)
                                }
                            }
                            self.callBack?.parsingFinished(arrNews as AnyObject?, withTag: obj.tag)
                        }
                        else
                        {
                            self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                            
                        }

                    }
                    else
                    {
                        self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                    }
                }
                else
                {
                    self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                }

            }
        }
        
    }
    func getNewsWith(ID : String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getNews.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "singleNews.php?newsId=" + ID
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                let obj : HttpRequest = HttpRequest()
                obj.tag = NSInteger(ParsingConstant.getNews.rawValue)
                obj.MethodNamee = "GET"
                obj._serviceURL = developer_API + "singleNews.php?newsId=" + ID
                obj.params = [:]
                
                obj.doGetSOAPResponse {(success : Bool) -> Void in
                    if !success
                    {
                        self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
                    }
                    else
                    {
                        let newsBO = NewsBO()
                        if let arrData  = obj.parsedDataDict["news"] as? [[String:AnyObject]]
                        {
                            if arrData.count > 0
                            {
                                for dictData in arrData
                                {
                                    if let News_ID = dictData["News_ID"] as? String
                                    {
                                        newsBO.News_ID = News_ID
                                    }
                                    if let Category = dictData["Category"] as? String
                                    {
                                        newsBO.Category = Category
                                    }
                                    if let Category_ID = dictData["Category_ID"] as? String
                                    {
                                        newsBO.Category_ID = Category_ID
                                    }
                                    if let News_Subject = dictData["News_Subject"] as? String
                                    {
                                        newsBO.News_Subject = News_Subject
                                    }
                                    if let News_VideoLink = dictData["News_VideoLink"] as? String
                                    {
                                        newsBO.News_VideoLink = News_VideoLink
                                    }
                                    if let News_Likes = dictData["News_Likes"] as? String
                                    {
                                        newsBO.News_Likes = News_Likes
                                    }
                                    if let News_Dislikes = dictData["News_Dislikes"] as? String
                                    {
                                        newsBO.News_Dislikes = News_Dislikes
                                    }
                                    if let IsBreakingNews = dictData["IsBreakingNews"] as? String
                                    {
                                        newsBO.IsBreakingNews = IsBreakingNews
                                    }
                                    if let News_Date = dictData["News_Date"] as? String
                                    {
                                        newsBO.News_Date = News_Date
                                    }
                                }
                            }
                            if let arrData  = obj.parsedDataDict["relatedNews"] as? [[String:AnyObject]]
                            {
                                if arrData.count > 0
                                {
                                    for dictData in arrData
                                    {
                                        let content = NewsBO()
                                        if let News_ID = dictData["News_ID"] as? String
                                        {
                                            content.News_ID = News_ID
                                        }
                                        if let Category = dictData["Category"] as? String
                                        {
                                            content.Category = Category
                                        }
                                        if let Category_ID = dictData["Category_ID"] as? String
                                        {
                                            content.Category_ID = Category_ID
                                        }
                                        if let News_Subject = dictData["News_Subject"] as? String
                                        {
                                            content.News_Subject = News_Subject
                                        }
                                        if let News_VideoLink = dictData["News_VideoLink"] as? String
                                        {
                                            content.News_VideoLink = News_VideoLink
                                        }
                                        if let News_Likes = dictData["News_Likes"] as? String
                                        {
                                            content.News_Likes = News_Likes
                                        }
                                        if let News_Dislikes = dictData["News_Dislikes"] as? String
                                        {
                                            content.News_Dislikes = News_Dislikes
                                        }
                                        if let IsBreakingNews = dictData["IsBreakingNews"] as? String
                                        {
                                            content.IsBreakingNews = IsBreakingNews
                                        }
                                        if let News_Date = dictData["News_Date"] as? String
                                        {
                                            content.News_Date = News_Date
                                        }
                                        newsBO.arrRelatedNews.append(content)
                                    }
                                }
                            }
                            self.callBack?.parsingFinished(newsBO as AnyObject?, withTag: obj.tag)
                        }
                        else
                        {
                            self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
                        }
                        
                    }
                }
                
            }
        }
        
    }
    func getTopNewsWith(ID : String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getTopNews.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "getTopnews.php?id=" + ID
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let isSuccess  = obj.parsedDataDict["success"] as? NSNumber
                {
                    if Bool(isSuccess) == true
                    {
                        if let arrData  = obj.parsedDataDict["news"] as? [[String:AnyObject]]
                        {
                            var arrNews = [NewsBO]()
                            if arrData.count > 0
                            {
                                for dictData in arrData
                                {
                                    let content = NewsBO()
                                    if let News_ID = dictData["News_ID"] as? String
                                    {
                                        content.News_ID = News_ID
                                    }
                                    if let Category = dictData["Category"] as? String
                                    {
                                        content.Category = Category
                                    }
                                    if let Category_ID = dictData["Category_ID"] as? String
                                    {
                                        content.Category_ID = Category_ID
                                    }
                                    if let News_Subject = dictData["News_Subject"] as? String
                                    {
                                        content.News_Subject = News_Subject
                                    }
                                    if let News_VideoLink = dictData["News_VideoLink"] as? String
                                    {
                                        content.News_VideoLink = News_VideoLink
                                    }
                                    if let News_Likes = dictData["News_Likes"] as? String
                                    {
                                        content.News_Likes = News_Likes
                                    }
                                    if let News_Dislikes = dictData["News_Dislikes"] as? String
                                    {
                                        content.News_Dislikes = News_Dislikes
                                    }
                                    if let IsBreakingNews = dictData["IsBreakingNews"] as? String
                                    {
                                        content.IsBreakingNews = IsBreakingNews
                                    }
                                    if let News_Date = dictData["News_Date"] as? String
                                    {
                                        content.News_Date = News_Date
                                    }
                                    arrNews.append(content)
                                }
                            }
                            self.callBack?.parsingFinished(arrNews as AnyObject?, withTag: obj.tag)
                        }
                        else
                        {
                            self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                            
                        }
                        
                    }
                    else
                    {
                        self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                    }
                }
                else
                {
                    self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
                
            }
        }
        
    }
    func getNewsWith(searchKey : String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getSearchresults.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "searchNews.php?searchKeyword=" + searchKey
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let isSuccess  = obj.parsedDataDict["success"] as? NSNumber
                {
                    if Bool(isSuccess) == true
                    {
                        if let arrData  = obj.parsedDataDict["news"] as? [[String:AnyObject]]
                        {
                            var arrNews = [NewsBO]()
                            if arrData.count > 0
                            {
                                for dictData in arrData
                                {
                                    let content = NewsBO()
                                    if let News_ID = dictData["News_ID"] as? String
                                    {
                                        content.News_ID = News_ID
                                    }
                                    if let Category = dictData["Category"] as? String
                                    {
                                        content.Category = Category
                                    }
                                    if let Category_ID = dictData["Category_ID"] as? String
                                    {
                                        content.Category_ID = Category_ID
                                    }
                                    if let News_Subject = dictData["News_Subject"] as? String
                                    {
                                        content.News_Subject = News_Subject
                                    }
                                    if let News_VideoLink = dictData["News_VideoLink"] as? String
                                    {
                                        content.News_VideoLink = News_VideoLink
                                    }
                                    if let News_Likes = dictData["News_Likes"] as? String
                                    {
                                        content.News_Likes = News_Likes
                                    }
                                    if let News_Dislikes = dictData["News_Dislikes"] as? String
                                    {
                                        content.News_Dislikes = News_Dislikes
                                    }
                                    if let IsBreakingNews = dictData["IsBreakingNews"] as? String
                                    {
                                        content.IsBreakingNews = IsBreakingNews
                                    }
                                    if let News_Date = dictData["News_Date"] as? String
                                    {
                                        content.News_Date = News_Date
                                    }
                                    arrNews.append(content)
                                }
                            }
                            self.callBack?.parsingFinished(arrNews as AnyObject?, withTag: obj.tag)
                        }
                        else
                        {
                            self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                            
                        }
                        
                    }
                    else
                    {
                        self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                    }
                }
                else
                {
                    self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
                
            }
        }
        
    }
    func getAllSlogans()
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.getAllSlogans.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "get_slogans.php"
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let isSuccess  = obj.parsedDataDict["success"] as? NSNumber
                {
                    if Bool(isSuccess) == true
                    {
                        if let arrData  = obj.parsedDataDict["Slogan"] as? [[String:AnyObject]]
                        {
                            var arrSlogans = [SloganBO]()
                            if arrData.count > 0
                            {
                                for dictData in arrData
                                {
                                    let content = NewsBO()
                                    if let Slogan_ID = dictData["Slogan_ID"] as? String
                                    {
                                        content.News_ID = Slogan_ID
                                    }
                                    if let Slogan_Content = dictData["Slogan_Content"] as? String
                                    {
                                        content.News_Subject = Slogan_Content
                                    }
                                    if let Slogan_Date = dictData["Slogan_Date"] as? String
                                    {
                                        content.News_Date = Slogan_Date
                                    }
                                    arrSlogans.append(SloganBO(Slogan_ID: content.News_ID, Slogan_Content: content.News_Subject, Slogan_Date: content.News_Date))
                                }
                            }
                            self.callBack?.parsingFinished(arrSlogans as AnyObject?, withTag: obj.tag)
                        }
                        else
                        {
                            self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                            
                        }
                        
                    }
                    else
                    {
                        self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                    }
                }
                else
                {
                    self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
                
            }
        }
        
    }
    func setLikeFor(newsId : String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.setLike.rawValue)
        obj.MethodNamee = "POST"
        obj._serviceURL = developer_API + "setLikes.php"
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        obj.ServiceBody = "newsId=" + newsId + "&mobileIMEI=" + deviceID + "&isLike=" + "1"
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let isSuccess  = obj.parsedDataDict["success"] as? NSNumber
                {
                    if Bool(isSuccess) == true
                    {
                        if let arrData  = obj.parsedDataDict["news"] as? [[String:AnyObject]]
                        {
                            var arrNews = [NewsBO]()
                            if arrData.count > 0
                            {
                                for dictData in arrData
                                {
                                    let content = NewsBO()
                                    if let News_ID = dictData["News_ID"] as? String
                                    {
                                        content.News_ID = News_ID
                                    }
                                    if let Category = dictData["Category"] as? String
                                    {
                                        content.Category = Category
                                    }
                                    if let Category_ID = dictData["Category_ID"] as? String
                                    {
                                        content.Category_ID = Category_ID
                                    }
                                    if let News_Subject = dictData["News_Subject"] as? String
                                    {
                                        content.News_Subject = News_Subject
                                    }
                                    if let News_VideoLink = dictData["News_VideoLink"] as? String
                                    {
                                        content.News_VideoLink = News_VideoLink
                                    }
                                    if let News_Likes = dictData["News_Likes"] as? String
                                    {
                                        content.News_Likes = News_Likes
                                    }
                                    if let News_Dislikes = dictData["News_Dislikes"] as? String
                                    {
                                        content.News_Dislikes = News_Dislikes
                                    }
                                    if let IsBreakingNews = dictData["IsBreakingNews"] as? String
                                    {
                                        content.IsBreakingNews = IsBreakingNews
                                    }
                                    if let News_Date = dictData["News_Date"] as? String
                                    {
                                        content.News_Date = News_Date
                                    }
                                    arrNews.append(content)
                                }
                            }
                            self.callBack?.parsingFinished(arrNews as AnyObject?, withTag: obj.tag)
                        }
                        else
                        {
                            self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                            
                        }
                        
                    }
                    else
                    {
                        self.callBack?.parsingFinished([NewsBO]() as AnyObject?, withTag: obj.tag)
                    }
                }
                else
                {
                    self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
                
            }
        }
        
    }
    func setFeedbackWith(emailId : String,rating : String,comments : String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.setLike.rawValue)
        obj.MethodNamee = "POST"
        obj._serviceURL = developer_API + "setFeedback.php"
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        obj.ServiceBody = "emailId=" + emailId + "&mobileIMEI=" + deviceID + "&rating=" + rating + "&comments" + comments
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let isSuccess  = obj.parsedDataDict["Success"] as? NSNumber
                {
                    if Bool(isSuccess) == true
                    {
                        self.callBack?.parsingFinished("success" as AnyObject?, withTag: obj.tag)
                    }
                    else
                    {
                        self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                    }
                }
                else
                {
                    self.callBack.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
                
            }
        }
        
    }
    //MARK: Supporting Methods
    func encodeSpecialCharactersManually(_ strParam : String)-> String
    {
        
        var strParams = strParam.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
        strParams = strParams!.replacingOccurrences(of: "&", with:"%26")
        return strParams!
    }
    
    func convertSpecialCharactersFromStringForAddress(_ strParam : String)-> String
    {
        
        var strParams = strParam.replacingOccurrences(of: "&", with:"&amp;")
        strParams = strParams.replacingOccurrences(of: ">", with: "&gt;")
        strParams = strParams.replacingOccurrences(of: "<", with: "&lt;")
        strParams = strParams.replacingOccurrences(of: "\"", with: "&quot;")
        strParams = strParams.replacingOccurrences(of: "'", with: "&apos;")
        return strParams
    }

}
