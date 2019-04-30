//
//  AvailableTableViewCell.swift
//  Slopac
//
//  Created by Jozef Varga on 02/03/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit

/// Table view cell for available table - where is book
class AvailableTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var lentLabel: UILabel!
    @IBOutlet weak var presenceLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var addressStaticLabel: UILabel!
    @IBOutlet weak var sublocationNameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    // MARK: - Variables
    var cellBookInformation = BookInformation(address: "", city: "", postal_code: "", latitude: 0.0, longtitude: 0.0, location_name: "", sublocation_name: "", available_books: 0, lent_books: 0, presence_books: 0)
    
    // MARK: - Function
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
