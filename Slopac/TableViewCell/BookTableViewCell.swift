//
//  BookTableViewCell.swift
//  Slopac
//
//  Created by Jozef Varga on 10/11/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

/// Table view cell for search book
class BookTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Function
    override func awakeFromNib() {
        super.awakeFromNib() 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func hiddenImage(){
        imageWidthConstraint.constant = 0.0
        imageHeightConstraint.constant = 0.0
    }
    
}
