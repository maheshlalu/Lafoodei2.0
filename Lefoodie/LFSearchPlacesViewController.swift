//
//  LFSearchPlacesViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 04/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit
class LFSearchPlacesViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    @IBOutlet weak var mapviewPlaces: MKMapView!
    
    var placesData = NSMutableArray()
    var uniqCatArray = NSArray()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var latAndLongData = NSMutableArray()
    var currentLocationName = String()
    
    @IBOutlet weak var placesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let mapView = LFMapInstance.MapView.init(frame: CGRect(x:0, y:292, width:self.view.frame.size.width, height:300))
        //        //LFMapInstance.sharedInstance.coordinate
        //        self.view.addSubview(mapView)
        //getTheCurrentLocationlatLong()
        NotificationCenter.default.addObserver(self, selector: #selector(LFSearchPlacesViewController.placesSearchNotification(_:)), name:NSNotification.Name(rawValue: "PlacesSearchNotification"), object: nil)
        
        
        let relamInstance = try! Realm()
        let places = relamInstance.objects(LFPlaces.self)
        try! relamInstance.write({
            relamInstance.delete(places)
        })
        
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading..")
        LFDataManager.sharedInstance.getTheAllRestarantsFromServer { (resultArray) in
            
            CXDataService.sharedInstance.hideLoader()
            self.getPlaceDetailsFromDB()
        }
        
    }
    
    func getTheCurrentLocationlatLong(){
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            if currentLocation != nil{
                let lat: Double = currentLocation.coordinate.latitude
                let latstr: String = String(format:"%f", lat)
                
                let long: Double = currentLocation.coordinate.longitude
                let longstr: String = String(format:"%f", long)
                let neardbystr: String = latstr + "|" + longstr + "|" + "200"
                // print("location \(neardbystr)") testing purpose "37.332331|-122.031219|200"
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl(), parameters: ["type":"allMalls" as AnyObject,"NearByMalls": "37.332331|-122.031219|200" as AnyObject]) { (responceDic) in
                    //  print("All data mapp \(responceDic)")
                    self.latAndLongData = NSMutableArray()
                    let orgsData : NSArray = (responceDic.value(forKey: "orgs") as?NSArray)!
                    for Data in orgsData{
                        self.latAndLongData.addObjects(from: [Data])
                    }
                    for i in 0 ..< self.latAndLongData.count
                    {
                        let dict = self.latAndLongData[i] as! NSDictionary
                        let center = CLLocationCoordinate2D(latitude: (dict.value(forKey: "latitude")! as AnyObject).doubleValue!, longitude: (dict.value(forKey: "longitude")! as AnyObject).doubleValue!)
                        let point = StarbucksAnnotation(coordinate: center)
                        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                        point.name = dict.value(forKey: "name") as? String
                        point.idstr = dict.value(forKey: "id") as? String
                        point.address = dict.value(forKey: "address") as? String
                       // point.image = UIImage(named: "pinpoient")
                        let url = URL(string: (dict.value(forKey: "logo") as? String)!)
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                            DispatchQueue.main.async {
                                point.image = UIImage(data: data!)
                            }
                        }
                        self.mapviewPlaces.setRegion(region, animated: true)
                        self.mapviewPlaces.addAnnotation(point)
                    }
                }
            }else{
                print("no location here")
            }
        }
    }
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapviewPlaces.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "pinpoient")
        //annotationView?.t
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let starbucksAnnotation = view.annotation as! StarbucksAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.starbucksName.text = starbucksAnnotation.name
        calloutView.starbucksAddress.text = starbucksAnnotation.address
        calloutView.starbucksPhone.text = starbucksAnnotation.idstr
        
        let button = UIButton(frame: calloutView.starbucksPhone.frame)
        button.addTarget(self, action: #selector(LFSearchPlacesViewController.callRestrarent(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        calloutView.starbucksImage.image = starbucksAnnotation.image
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.46)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
        //        if let annotationTitle = view.annotation?.title
        //        {
        //            // print("User tapped on annotation with title: \(annotationTitle!)")
        //            let view1 = UIView()
        //            view1.frame = CGRect(origin: CGPoint(x: -40,y : -30), size: CGSize(width: 100, height: 28))
        //            view1.backgroundColor = UIColor.lightGray
        //            //view1.center = CGPoint(x: view.bounds.size.width / 2, y: -view1.bounds.size.height*0.52)
        //            let name = UILabel()
        //            name.frame = CGRect(origin: CGPoint(x: 1,y : 2), size: CGSize(width: 80, height: 20))
        //            name.text = " " + annotationTitle!
        //            name.font = UIFont.systemFont(ofSize: 9.0)
        //            name.textColor = UIColor.white
        //            view1.addSubview(name)
        //            let discloseBtn = UIButton(type: .detailDisclosure)
        //            discloseBtn.frame = CGRect(origin: CGPoint(x: 75,y : 3), size: CGSize(width: 20, height: 20))
        //            discloseBtn.addTarget(self, action: #selector(disclosuseBtnClicked), for: .touchUpInside)
        //            view1.addSubview(discloseBtn)
        //            view.addSubview(view1)
        //            view1.layer.borderWidth = 1
        //            view1.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        //            mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        //        }
    }
    
    //MARK: restrurent Button action
    
    func callRestrarent(sender: UIButton)
    {
        let v = sender.superview as! CustomCalloutView
        let id: String = v.starbucksPhone.text!
        for i in 0 ..< self.latAndLongData.count{
            let dict = self.latAndLongData[i] as! NSDictionary
            if id == dict.value(forKey: "id") as? String {
                // print("restrarent tapped ")
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let profileContoller : LFUserProfileViewController = (storyBoard.instantiateViewController(withIdentifier: "LFUserProfileViewController") as? LFUserProfileViewController)!
                profileContoller.profileDetails = ProfileDetailsType.restaurantsType
                profileContoller.subAminId = id
                profileContoller.rEmail = dict.value(forKey: "email") as? String
                profileContoller.isFromHome = true
                self.navigationController?.pushViewController(profileContoller, animated: true)
            }else{
                print("not restrarent tapped ")
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTheCurrentLocationlatLong()
        
    }
    
    func getPlaceDetailsFromDB()
    {
        
        let realm = try! Realm()
        let  data = realm.objects(LFPlaces.self)
        let categoryArr = NSMutableArray()
        
        
        //        for (index,value) in data.enumerated() {
        //
        //        }
        
        for obj in data {
            categoryArr.add(obj.category)
            placesData.add(obj)
        }
        
        //        for i in 0...data.count - 1 {
        //            let obj = data[i]
        //            categoryArr.add(obj.category)
        //            placesData.add(obj)
        //        }
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
