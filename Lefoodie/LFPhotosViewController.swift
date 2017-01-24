//
//  LFPhotosViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 03/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFPhotosViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITabBarControllerDelegate {
var canScrollToTop:Bool = true
    @IBOutlet weak var photoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.photoCollectionView.resetScrollPositionToTop()
        photoCollectionView.setContentOffset(CGPoint.zero, animated: true)
        
        let nib = UINib(nibName: "LFPhotoCollectionViewCell", bundle: nil)
        self.photoCollectionView.register(nib, forCellWithReuseIdentifier: "LFPhotoCollectionViewCell")
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        
//        // Allows scrolling to top on second tab bar click
//        if (viewController.isKindOfClass(CustomNavigationBarClass) && tabBarController.selectedIndex == 0) {
//            if (viewControllerRef!.canScrollToTop) {
//                viewControllerRef!.scrollToTop()
//            }
//        }
//    }
//    
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LFPhotoCollectionViewCell", for: indexPath)as? LFPhotoCollectionViewCell
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width/2-10,height: 150)
        
    }
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        canScrollToTop = true
    }
    
    // Called when the view becomes unavailable
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canScrollToTop = false
    }
}



