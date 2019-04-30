//
//  SelectLibraryForSearchTableViewCell.swift
//  Slopac
//
//  Created by Jozef Varga on 23/02/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit

/// Table view cell for library
class SelectLibraryForSearchTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var selectSwitch: UISwitch!
    @IBOutlet weak var textLeftConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var idLibrary = -1
    var nameToSuperViewConstraintSave = 0
    var nameToSwitchConstraintSave = 0
    var cellLibraryId = [Int]()
    
    // MARK: - Function
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        let viewForHighlight = UIView()
        self.selectedBackgroundView = viewForHighlight
        if self.isEditing {
            viewForHighlight.backgroundColor = COLOR_THEME_WHITE
        } else {
            viewForHighlight.backgroundColor = COLOR_THEME
        }
    }
    
    func setLeftConstraint(value: CGFloat){
        textLeftConstraint.constant = value
    }
    
    func changeSwitchValue() {
        print("SSSWWWIIITTTCHH")
        if(selectSwitch.isOn == false){
            selectSwitch.setOn(true, animated: true)
            LIBRARYID += [getId()]
            let help = LIBRARYID
            LIBRARYID.removeAll()
            let libraryData = DatabaseHandler.fetchDataLibrariesSort()!
            for library in libraryData {
                if((help.first(where: { $0 == library.id })) != nil){
                    LIBRARYID.append(Int(library.id))
                }
            }
            
            
        }
        else {
            selectSwitch.setOn(false, animated: true)
            if let findIdLibrary = LIBRARYID.index(of: getId()) {
                LIBRARYID.remove(at: findIdLibrary)
            }
        }
    }
    
    func setId(id: Int){
        idLibrary = id
    }
    
    func getId() -> Int{
        return idLibrary
    } 
}
