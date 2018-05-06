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
    
    let defaultItems = Item.samples() ?? []
    
    var items: [Item] = []
    
    fileprivate let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return control
    }()

    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items.append(contentsOf: defaultItems)
        
        collectionView.addSubview(refreshControl)
        
        collectionView.dataSource = self
        navigationItem.title = "Home"
        
        
        itemsService.getAllItems(successBlock: {[weak self] (items) in
            var newItems: [Item] = []
            newItems.append(contentsOf: items)
            newItems.append(contentsOf: self?.defaultItems ?? [])
            self?.items = newItems
            self?.collectionView.reloadData()
            }, failureBlock: nil)
    }
    
    // MARK: Actions
    @objc func refresh(_ sender: Any) {
        // Do refresh content
        itemsService.getAllItems(successBlock: {[weak self] (items) in
            var newItems: [Item] = []
            newItems.append(contentsOf: items)
            newItems.append(contentsOf: self?.defaultItems ?? [])
            self?.items = newItems
            self?.collectionView.reloadData()
            
            self?.refreshControl.endRefreshing()
            }, failureBlock: {[weak self] _ in
                
                self?.refreshControl.endRefreshing()
        })
        
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
