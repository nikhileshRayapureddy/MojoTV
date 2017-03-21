//
//  HomeCustomCell.swift
//  Mojo
//
//  Created by NIKHILESH on 18/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class HomeCustomCell: UITableViewCell {
    @IBOutlet weak var imgVwNews: UIImageView!
    @IBOutlet weak var lblNews: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
