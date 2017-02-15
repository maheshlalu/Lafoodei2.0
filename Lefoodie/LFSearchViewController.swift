//
//  ViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 03/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit

class LFSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var searchTypeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var count = Int()
    var navController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTypeLabel.layer.cornerRadius = 3
        searchTypeLabel.clipsToBounds = true
        
        count = 2
        searchTypeLabel.text = "Places"
        prevBtn.isEnabled = false
  
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func nextBtnAction(_ sender: AnyObject) {

        var destVC = UIViewController()
        
        if count == 1 {
            count = 2
            destVC = self.storyboard!.instantiateViewController(withIdentifier: "LFSearchPlacesViewController") as! LFSearchPlacesViewController
            searchTypeLabel.text = "Places"
            prevBtn.isEnabled = false
            nextBtn.isEnabled = true
            
            
        }
        else if count == 2 {
            count = 3
            
            destVC = self.storyboard!.instantiateViewController(withIdentifier: "LFFoodieViewController") as! LFFoodieViewController
            searchTypeLabel.text = "Foodies"
            prevBtn.isEnabled = true
            nextBtn.isEnabled = true
            
        }
        else if count == 3 {
            count = 1
            
            destVC = self.storyboard!.instantiateViewController(withIdentifier: "LFHashTagsViewController") as! LFHashTagsViewController
            searchTypeLabel.text = "Hashtags"
            prevBtn.isEnabled = true
            nextBtn.isEnabled = true
            
            
        }
        
        navController = UINavigationController(rootViewController: destVC)
        navController.isNavigationBarHidden = true
        
        addChildViewController(self.navController)
        self.navController.view.frame = self.containerView.bounds
        self.containerView.addSubview(navController.view)
        
        
        
    }
    
    @IBAction func prevBtnAction(_ sender: AnyObject) {
        
        if count > 1 {
            count = count - 1
            var destVC = UIViewController()
            
            if count == 1 {
                
                destVC = self.storyboard!.instantiateViewController(withIdentifier: "LFSearchPlacesViewController") as! LFSearchPlacesViewController
                searchTypeLabel.text = "Places"
                prevBtn.isEnabled = false
                nextBtn.isEnabled = true
                
                
            }
            else if count == 2 {
                
                destVC = self.storyboard!.instantiateViewController(withIdentifier: "LFFoodieViewController") as! LFFoodieViewController
                searchTypeLabel.text = "Foodies"
                prevBtn.isEnabled = true
                nextBtn.isEnabled = true
                
                
            }
            else if count == 3 {
                
                destVC = self.storyboard!.instantiateViewController(withIdentifier: "LFHashTagsViewController") as! LFHashTagsViewController
                searchTypeLabel.text = "Hashtags"
                prevBtn.isEnabled = true
                nextBtn.isEnabled = false
                
            }
            
            navController = UINavigationController(rootViewController: destVC)
            navController.isNavigationBarHidden = true
            
            addChildViewController(self.navController)
            self.navController.view.frame = self.containerView.bounds
            self.containerView.addSubview(navController.view)
            
        }
        
    }
}

extension LFSearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar){
        self.searchBar.resignFirstResponder()
        self.doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // print("search string \(searchText)")
        if (self.searchBar.text!.characters.count > 0) {
        } else if self.searchBar.text!.characters.count == 0{
            // self.loadDefaultList()
            //self.search.removeFromParentViewController()
            
            //self.search.willMoveToParentViewController(nil)
            //self.search.view.removeFromSuperview()
            //self.offersTableView.reloadData()
            print("inMethodCharectersCount0")
          
        }else if searchText.isEmpty{
            //self.search.view.removeFromSuperview()
            //self.offersTableView.reloadData()
            print("SearchTextEmptyMethod")
        }
        
    }
    
    func loadDefaultList (){
        if count == 2{
            print("Foodie section")
            
        }
    }
    
    func refreshSearchBar (){
        self.searchBar.resignFirstResponder()
        // Clear search bar text
        self.searchBar.text = "";
        // Hide the cancel button
        self.searchBar.showsCancelButton = false;
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.refreshSearchBar()
        self.loadDefaultList()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
  
    }
    
    func removeSearch(){
        
    }
    
    func doSearch () {
        
        if count == 3{
        print("Foodie section")
        
        }
//        self.search = self.storyboard?.instantiateViewController(withIdentifier: "ProductSearchViewController") as! ProductSearchViewController
//        search.view.frame = CGRect(x: 0,y: self.productsSearchBar.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        self.view.addSubview(search.view)
//        addChildViewController(search)
//        search.didMove(toParentViewController: self)
//        
//        
//        let productEn = NSEntityDescription.entity(forEntityName: "CX_Products", in: NSManagedObjectContext.mr_contextForCurrentThread())
//        let predicate:NSPredicate =  NSPredicate(format: "name contains[c] %@",self.productsSearchBar.text!)
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CX_Products.mr_requestAllSorted(by: "pid", ascending: false)
//        fetchRequest.predicate = predicate
//        fetchRequest.entity = productEn
//        self.search.products = CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray
//        self.search.updatecollectionview.reloadData()
    }
}





