//
//  AboutUsViewController.swift
//  ViralMojo
//
//  Created by Nikhilesh on 21/03/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavBar(IsBack: true, isLogo:false, strTitle: "About Us")
        webView.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "aboutus", ofType: "html")!)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
