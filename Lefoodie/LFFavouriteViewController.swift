//
//  LFFavouriteViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 03/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFFavouriteViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favouritesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 180, right: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "LFFavouritesCollectionViewCell", bundle: nil)
        self.favouritesCollectionView.register(nib, forCellWithReuseIdentifier: "LFFavouritesCollectionViewCell")
        self.view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return 5
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LFFavouritesCollectionViewCell", for: indexPath)as? LFFavouritesCollectionViewCell
        return cell!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width/1-10,height: 150)
        
    }
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    


  

}
