//
//  LFSearchPlacesViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 04/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit
import RealmSwift

class LFSearchPlacesViewController: UIViewController {
    
    var placesData = NSMutableArray()
    var uniqCatArray = NSArray()
    
    @IBOutlet weak var placesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = LFMapInstance.MapView.init(frame: CGRect(x:0, y:292, width:self.view.frame.size.width, height:300))
        self.view.addSubview(mapView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LFSearchPlacesViewController.placesSearchNotification(_:)), name:NSNotification.Name(rawValue: "PlacesSearchNotification"), object: nil)
        
        self.getPlaceDetailsFromDB()
    }
    
    func getPlaceDetailsFromDB()
    {
       
        let realm = try! Realm()
       let  data = realm.objects(LFPlaces.self)
        let categoryArr = NSMutableArray()
        for i in 0...data.count - 1 {
            let obj = data[i]
            categoryArr.add(obj.category)
            placesData.add(obj)
        }
        let catOnlyDict = NSMutableDictionary()
        for i in 0...categoryArr.count - 1 {
            let type = categoryArr[i] as! String
            catOnlyDict.setValue("foo", forKey: type)
        }
        uniqCatArray =  catOnlyDict.allKeys as NSArray
        self.placesCollectionView.reloadData()
    }
    
    
    
    
    func placesSearchNotification(_ notification: Notification) {
        let searchText = notification.object as! String
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UICollectionViewDataSource
extension LFSearchPlacesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uniqCatArray.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearByCell",for: indexPath) as! LFNearByCollectionViewCell
        
        let catType = uniqCatArray[indexPath.row] as! String
        var data = LFPlaces()
        for i in 0...placesData.count - 1 {
            let obj = placesData[i] as! LFPlaces
            if obj.category == catType {
                data = obj
                break
            }
        }
        
        cell.placeName.text = data.category
        cell.placeImage.sd_setImage(with: NSURL.init(string: data.image) as URL!, placeholderImage: nil)
        
        // Configure the cell
        return cell
    }
    
}
