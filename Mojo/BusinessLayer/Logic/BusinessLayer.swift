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

let developer_API = "http://myryd.com/usrapp/api/v1/"
class BusinessLayer: BaseBL {
    //MARK: Supporting Methods
    func checkCastId(castId : String)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.checkcastid.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "checkcastid/castid=" + castId
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let isSuccess  = obj.parsedDataDict["error"] as? String
                {
                    if Bool(isSuccess) == false
                    {
                        var arrContent = [ContentBO]()
                        if let arrData  = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                        {
                            if arrData.count > 0
                            {
                                for dictData in arrData
                                {
                                    let content = ContentBO()
                                    if let FileUrl = dictData["FileUrl"] as? String
                                    {
                                        content.strFileUrl = FileUrl
                                    }
                                    if let thumbnail = dictData["thumbnail"] as? String
                                    {
                                        content.strThumbnail = thumbnail
                                    }
                                    if let Name = dictData["Name"] as? String
                                    {
                                        content.strName = Name
                                    }
                                    if let FileKey = dictData["FileKey"] as? String
                                    {
                                        content.strFileKey = FileKey
                                    }
                                    if let Channel = dictData["Channel"] as? String
                                    {
                                        content.strChannel = Channel
                                    }
                                    if let Language = dictData["Language"] as? String
                                    {
                                        content.strLanguage = Language
                                    }
                                    if let Uploadedon = dictData["Uploadedon"] as? String
                                    {
                                        content.strUploadedon = Uploadedon
                                    }
                                    arrContent.append(content)
                                }
                            }
                        }
                        
                        Foundation.UserDefaults.standard.set(castId, forKey:"CASTID")
                        Foundation.UserDefaults.standard.synchronize()

                        self.callBack?.parsingFinished(arrContent as AnyObject?, withTag: obj.tag)
                    }
                    else
                    {
                        if let Msg : String = obj.parsedDataDict["message"] as? String
                        {
                            self.callBack.parsingError(Msg, withTag: obj.tag)
                        }
                        else
                        {
                            self.callBack?.parsingError(SERVER_ERROR , withTag: obj.tag)
                            
                        }
                    }
                }
                else
                {
                    self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
            }
        }

    }
    func streamWith(fileId : String)
    {
        //http://myryd.com/usrapp/api/v1/stream/file=GMbGlLDwc5P/castid=6043
        
        let castID = Foundation.UserDefaults.standard.object(forKey: "CASTID") as! String
        let obj : HttpRequest = HttpRequest()
        obj.tag = NSInteger(ParsingConstant.checkcastid.rawValue)
        obj.MethodNamee = "GET"
        obj._serviceURL = developer_API + "stream/file=" + fileId + "/castid=" + castID
        obj.params = [:]
        
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
            }
            else
            {
                if let isSuccess  = obj.parsedDataDict["error"] as? String
                {
                    if Bool(isSuccess) == false
                    {
                        var arrContent = [ContentBO]()
                        if let arrData  = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                        {
                            if arrData.count > 0
                            {
                                for dictData in arrData
                                {
                                    let content = ContentBO()
                                    if let FileUrl = dictData["FileUrl"] as? String
                                    {
                                        content.strFileUrl = FileUrl
                                    }
                                    if let thumbnail = dictData["thumbnail"] as? String
                                    {
                                        content.strThumbnail = thumbnail
                                    }
                                    if let Name = dictData["Name"] as? String
                                    {
                                        content.strName = Name
                                    }
                                    if let FileKey = dictData["FileKey"] as? String
                                    {
                                        content.strFileKey = FileKey
                                    }
                                    if let Channel = dictData["Channel"] as? String
                                    {
                                        content.strChannel = Channel
                                    }
                                    if let Language = dictData["Language"] as? String
                                    {
                                        content.strLanguage = Language
                                    }
                                    if let Uploadedon = dictData["Uploadedon"] as? String
                                    {
                                        content.strUploadedon = Uploadedon
                                    }
                                    arrContent.append(content)
                                }
                            }
                        }
                        self.callBack?.parsingFinished(arrContent as AnyObject?, withTag: obj.tag)
                    }
                    else
                    {
                        if let Msg : String = obj.parsedDataDict["message"] as? String
                        {
                            self.callBack.parsingError(Msg, withTag: obj.tag)
                        }
                        else
                        {
                            self.callBack?.parsingError(SERVER_ERROR , withTag: obj.tag)
                            
                        }
                    }
                }
                else
                {
                    self.callBack?.parsingError(SERVER_ERROR, withTag: obj.tag)
                }
            }
        }
        
    }

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
