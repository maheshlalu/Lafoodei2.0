//
//  LFPlacesSearchViewController.swift
//  Lefoodie
//
//  Created by Rambabu Mannam on 23/02/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import MapKit
import Cosmos

class LFPlacesSearchViewController: UIViewController,CLLocationManagerDelegate {
    
    var locManager = CLLocationManager()
    var currentLocationName = String()
    var searchPlaces = NSArray()
    
    @IBOutlet weak var searchPlacesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findMyLocation()
        //setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUpNavigationBar()
//        searchPlacesTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    func setUpTableView()
    {
        searchPlacesTableView.estimatedRowHeight = 80
        searchPlacesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setUpNavigationBar()
    {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        let menuItem = UIBarButtonItem(image: UIImage(named: "Back-48"), style: .plain, target: self, action: #selector(LFRestaurentDetailsViewController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func backBtnClicked()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Automatic Location Detection Methods
    func findMyLocation() {
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Identifying")
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                manager.stopUpdatingLocation()
                let pm = (placemarks?[0])! as CLPlacemark
                self.displayLocationInfo(placemark: pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        if placemark != nil {
            //stop updating location to save battery life
            locManager.stopUpdatingLocation()
            //            print(placemark.subLocality)
            //            print(placemark.postalCode)
            //            print(placemark.administrativeArea)
            //            print(placemark.subAdministrativeArea)
            //            print(placemark.country)
            //            print(placemark.locality)
            //            print(placemark.location)
            //            print(placemark.name)
            //            print(placemark.region)
            let descriptions: [AnyHashable: Any] = placemark.addressDictionary!
            print(placemark.addressDictionary)
            // print(descriptions["FormattedAddressLines"])
            let addressArray : NSArray = descriptions["FormattedAddressLines"] as! NSArray
            //  print(addressArray)
            let addressStr : String = addressArray.componentsJoined(by: ",")
            // print(addressStr)
            CXDataService.sharedInstance.hideLoader()
            currentLocationName = placemark.subLocality!
            //self.addressTextField.text = addressStr
            
        }
    }

    //MARK: Getting Place search results
    func getPlaceSearchResults(searchText:String,locationName:String)
    {
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading..")
        let urlStr = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getSearchResultsApi()
        let paramDic = ["name":searchText,"address":locationName]
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(urlStr, parameters: paramDic as [String : AnyObject]?) { (responseDic) in
            print(responseDic)
            self.searchPlaces = responseDic.value(forKey: "orgs") as! NSArray
            self.searchPlacesTableView.reloadData()
            CXDataService.sharedInstance.hideLoader()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: UISearchBar Delegate Methods
extension LFPlacesSearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        getPlaceSearchResults(searchText: searchBar.text!, locationName: currentLocationName)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.refreshSearchBar()
//        self.loadDefaultList()
    }
}

//MARK: UITableView Delegate Methods
extension LFPlacesSearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchPlaces.count
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchPlacesCell") as! LFPlacesSearchTableViewCell
    
        let dict = searchPlaces[indexPath.row] as! NSDictionary
        let imgStr = dict.value(forKey: "icon") as! String
        let imgUrl = URL(string: imgStr) as URL!
    
        if imgUrl != nil{
            cell.placeImageView.setImageWith(imgUrl, usingActivityIndicatorStyle: .gray)
           
        }else{
            cell.placeImageView.image = UIImage(named: "placeHolder")
        }
        //cell.placeImageView.contentMode = UIViewContentMode.scaleAspectFit
        cell.placeName.text = dict.value(forKey: "name") as? String
        cell.ratingView.rating = Double(Float(dict.value(forKey: "rating") as! String)!)
        cell.ratingView.isUserInteractionEnabled = false
        let str = dict.value(forKey: "formatted_address") as? NSString
        cell.addressLabel.text = str?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return cell
   }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
   {
        let dict = searchPlaces[indexPath.row] as! NSDictionary
        let reference = dict.value(forKey: "reference") as! String
        let urlStr = NSString.init(format: "http://storeongo.com/MobileBuild/demo?reference=%@", reference)
        tableView.deselectRow(at: indexPath, animated: true)
        let destVC = self.storyboard!.instantiateViewController(withIdentifier: "LFWebViewNavigationController") as! UINavigationController
        UserDefaults.standard.set(urlStr, forKey: "WebViewURLString")
        UserDefaults.standard.synchronize()
       // destVC.urlStr = urlStr as String
       // self.navigationController?.pushViewController(destVC, animated: true)
        self.present(destVC, animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
}

