//
//  ChackBookTableViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 03/03/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit

/// Show all Library Card for Checking lent book
class ChackBookTableViewController: UITableViewController {
    
    // MARK: - Variables
    var cardData : [LibraryCardCoreData]?
    var noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    // MARK: - Start function, text and UX settup
    override func viewDidLoad() {
        super.viewDidLoad()
        setUX()
        setText()
        loadLibraryCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLibraryCard()
    }
    
    func setUX(){
        self.tableView.rowHeight = UITableView.automaticDimension
        view.backgroundColor = COLOR_THEME
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.customLabel()
        noDataLabel.textAlignment = .center
        tableView.backgroundView = noDataLabel
    }
    
    func setText(){
        self.navigationItem.title = "choice_passport".localized
        noDataLabel.text = "no_passes".localized
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (cardData?.count)! > 0 {
            tableView.separatorStyle = .singleLine
            noDataLabel.isHidden = true
        }
        else{
            tableView.separatorStyle  = .none
            noDataLabel.isHidden = false
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cardData?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CheckBookTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CheckBookTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LibraryCardTableViewCell.")
        }
        let card = cardData?[indexPath.row]
        var library = DatabaseHandler.fetchDataLibrariesFromId(id: String((card?.library_id)!))
        cell.backgroundColor = COLOR_THEME
        cell.libraryCardNameLabel.customSmallCellTableLabel(text: card!.library_name!)
        cell.libraryNameLabel.customCellTableLabel(text: (library?[0].library_name)!)
        cell.accessoryType = .disclosureIndicator
        if((card?.date)! < Date()){
            cell.expirationImageView.image = UIImage(named: "icon_importance_red")!
            cell.expirationRightConstraint.constant = 0
            cell.expirationImageView.isHidden = false
        }
        else{
            cell.expirationRightConstraint.constant = -30
            cell.expirationImageView.isHidden = true
        }
        return cell
    }
    
    func updateData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadLibraryCard(){
        cardData = DatabaseHandler.fetchDataLibraryCardWithoutDelete()!
        if((cardData?.count)! > 0){
            updateData()
        }
    }
}
