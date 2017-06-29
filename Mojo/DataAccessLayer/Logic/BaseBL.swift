//
//  BaseBL.swift
//  HumaraShop
//
//  Created by MARTJACK on 10/27/15.
//  Copyright (c) 2015 Mery. All rights reserved.
//

import UIKit

import Foundation
//enum ParsingConstant : Int
//{
//    case internetLoss = 1000, letter2,letter3
//    
//}


enum ParsingConstant : Int
{
  case getBanners = 1000,
    checkcastid,
    getCategories,
    getNews,
    getTopNews,
    getAllNews,
    getSearchresults,
    getAllSlogans,
    internetLoss,
    setLike,
    checkLike,
    getAllFlashNews
}


 protocol ParserDelegate{
     func parsingFinished (_ object: AnyObject?, withTag tag: NSInteger)
     func parsingError (_ error: String?, withTag tag: NSInteger)
}

 class BaseBL: NSObject {
    
    let NoInternet : String = "There seems to be some data connectivity issue with your network. Please check connection and try again."
    
    var callBack : ParserDelegate!
    
   
    
    func checkForInternet () {
//        if callBack!.respondsToSelector(Selector ("parsingError:withTag:")) {
            callBack!.parsingError(NoInternet, withTag: ParsingConstant.internetLoss.rawValue)
     //   }

        return
    }

   
}
