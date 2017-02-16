//
//  LFFoodieViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 04/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit

class LFFoodieViewController: UIViewController {
    var foodiesArr = [SearchFoodies]()
    
    @IBOutlet weak var foodieViewTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceAPICall(keyword:"")
    }
    
    //MARK: calling foodie data from service
    func serviceAPICall(keyword: String){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        LFDataManager.sharedInstance.getSearchFoodie(keyword: keyword) { (resultFoodies) in
            self.foodiesArr = resultFoodies
            self.foodieViewTableView.reloadData()
        }
    }
}

//MARK: UITableView Delagate Methods
extension LFFoodieViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodiesArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodies = self.foodiesArr[indexPath.row]
        // Instantiate a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodieCell", for: indexPath) as! LFFoodiesTableViewCell
        cell.foodieImageView.layer.cornerRadius = 30
        cell.foodieImageView.clipsToBounds = true
        let imgUrl = URL(string: foodies.foodieImage) as URL!
        
        if imgUrl != nil{
            cell.foodieImageView.setImageWith(imgUrl, usingActivityIndicatorStyle: .gray)
            
        }else{
            cell.foodieImageView.image = UIImage(named: "placeHolder")
        }
        
        cell.foodieName.text = foodies.foodieName
        let following = foodies.foodieFollowingCount
        let follower = foodies.foodieFollowerCount
        cell.foodieFollowLbl.text = "\(follower) Followers . \(following) Following"
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //LFRestaurentDetailsViewController
        let dict = foodiesArr[indexPath.row]
        let restaurentView = self.storyboard!.instantiateViewController(withIdentifier: "LFRestaurentDetailsViewController") as! LFRestaurentDetailsViewController
        restaurentView.selectedFoodie = dict
        let navController = UINavigationController(rootViewController: restaurentView)
        navController.navigationItem.hidesBackButton = false
        self.present(navController, animated:true, completion: nil)
    }
}
