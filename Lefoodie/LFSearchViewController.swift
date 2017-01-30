//
//  ViewController.swift
//  LeFoodie
//
//  Created by Rambabu Mannam on 03/01/17.
//  Copyright © 2017 Rambabu Mannam. All rights reserved.
//

import UIKit

class LFSearchViewController: UIViewController,UISearchBarDelegate {
    
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
        
        count = 1
        searchTypeLabel.text = "Places"
        prevBtn.isEnabled = false

        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func nextBtnAction(_ sender: AnyObject) {
        if count < 3 {
            count = count + 1
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




