//
//  LibraryCardTableViewCell.swift
//  Slopac
//
//  Created by Jozef Varga on 15/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

/// Table view cell for library card
class LibraryCardTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var expirationImageView: UIImageView!
    @IBOutlet weak var expirationImageRightConstraint: NSLayoutConstraint!
    
    // MARK: - Function
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) 
    }
    
}
