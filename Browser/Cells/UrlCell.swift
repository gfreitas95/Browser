//
//  UrlCell.swift
//  Browser
//
//  Created by Gustavo on 27/08/20.
//  Copyright © 2020 Gustavo. All rights reserved.
//

import UIKit

class UrlCell: UITableViewCell {
    
    @IBOutlet var lblUrl: UILabel?
    @IBOutlet var lblDate: UILabel?
    
    func loadUI(item: Url) {
        
        lblUrl?.text = item.url
        lblDate?.text = item.date
    }
}
