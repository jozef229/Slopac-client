//
//  CheckBookTableViewCell.swift
//  Slopac
//
//  Created by Jozef Varga on 03/03/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit

/// Table view cell for check lent book
class CheckBookTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var libraryCardNameLabel: UILabel!
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var expirationImageView: UIImageView!
    @IBOutlet weak var expirationRightConstraint: NSLayoutConstraint!
    
    // MARK: - Function
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
