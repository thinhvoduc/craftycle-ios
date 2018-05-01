//
//  HomeViewController.swift
//  Craftycle
//
//  Created by Thinh Vo on 27/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var itemsService = ItemService(ServiceConfiguration.defaultAppConfiguration()!)
    
//    fileprivate lazy var refreshControl:
    
    var items: [Item] = Item.samples() ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        navigationItem.title = "Home"
        
        itemsService.getAllItems(successBlock: {[weak self] (items) in
            self?.items.append(contentsOf: items)
            self?.collectionView.reloadData()
        }, failureBlock: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        cell.item = items[indexPath.row]
        return cell
    }
}
