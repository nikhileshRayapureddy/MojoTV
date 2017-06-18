//
//  SloganBO.swift
//  Mojo
//
//  Created by NIKHILESH on 22/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class SloganBO: NSObject,NSCoding {
    var Slogan_ID = ""
    var Slogan_Content = ""
    var Slogan_Date = ""
    init(Slogan_ID: String, Slogan_Content:String, Slogan_Date: String) {
        self.Slogan_ID = Slogan_ID
        self.Slogan_Content = Slogan_Content
        self.Slogan_Date = Slogan_Date
        
    }
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "Slogan_ID") as! String
        let name = aDecoder.decodeObject(forKey: "Slogan_Content") as! String
        let shortname = aDecoder.decodeObject(forKey: "Slogan_Date") as! String
        self.init(Slogan_ID: id, Slogan_Content: name, Slogan_Date: shortname)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Slogan_Date, forKey: "Slogan_ID")
        aCoder.encode(self.Slogan_Content, forKey: "Slogan_Content")
        aCoder.encode(self.Slogan_Date, forKey: "Slogan_Date")
    }

}
