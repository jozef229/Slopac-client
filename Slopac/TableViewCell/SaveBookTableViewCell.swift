//
//  SaveBookTableViewCell.swift
//  Slopac
//
//  Created by Jozef Varga on 15/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

/// Table view cell for save favorite book
class SaveBookTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    // MARK: - Function
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
