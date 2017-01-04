//
//  LFSearchPlacesViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 04/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit

class LFSearchPlacesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = LFMapInstance.MapView.init(frame: CGRect(x:0, y:292, width:self.view.frame.size.width, height:300))
        self.view.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

// MARK: - UICollectionViewDataSource
extension LFSearchPlacesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearByCell",for: indexPath) as! LFNearByCollectionViewCell
        
        // Configure the cell
        return cell
    }
    
}
