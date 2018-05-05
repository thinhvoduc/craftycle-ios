//
//  SellTableViewController.swift
//  Craftycle
//
//  Created by iosdev on 2.5.2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class SellTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var sellItems = [Sell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let cell = Sell(sellOrCraft: "as", photo: #imageLiteral(resourceName: "placeholder"), place: "as", price: "as")
        sellItems.append(cell!)
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellItems.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaleTabTableViewCell", for: indexPath)  as! SaleTabTableViewCell
        
        let selling = sellItems[indexPath.row]
        
        cell.imagePlace.image = selling.photo
        
        return cell
    }
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        guard let vc = sender.source as? CreateMarketItemViewController, let sellItem = vc.sellItem else {
            return
        }
        
        sellItems.append(sellItem)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
