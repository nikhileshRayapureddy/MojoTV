//
//  NewsBO.swift
//  Mojo
//
//  Created by NIKHILESH on 18/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class NewsBO: NSObject {
    var News_ID = ""
    var Category = ""
    var Category_ID = ""
    var News_Subject = ""
    var News_Short_Subject = ""
    var News_VideoLink = ""
    var News_Image = ""
    var News_Likes = ""
    var News_Dislikes = ""
    var IsBreakingNews = ""
    var News_Date = ""
    var isLiked = "0"
    var arrRelatedNews = [NewsBO]()
    
}
