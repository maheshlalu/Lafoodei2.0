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
    var lastContentOffse:CGPoint = CGPoint()
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var parantNavigationController = UINavigationController()
    
    var intrinsicContentSize: CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 180, right: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        photoCollectionView.setContentOffset(CGPoint.zero, animated: true)
        
        let nib = UINib(nibName: "LFPhotoCollectionViewCell", bundle: nil)
        self.photoCollectionView.register(nib, forCellWithReuseIdentifier: "LFPhotoCollectionViewCell")
        self.view.backgroundColor = UIColor.white
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 20
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFItemDetailViewController")as? LFItemDetailViewController
        self.parantNavigationController.pushViewController(storyboard!, animated: true)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset: CGPoint = scrollView.contentOffset
        if currentOffset.y > self.lastContentOffse.y {
            print("UP")
            
        }
        else {
            print("Down")
            

        }
        self.lastContentOffse = currentOffset
    }
}



