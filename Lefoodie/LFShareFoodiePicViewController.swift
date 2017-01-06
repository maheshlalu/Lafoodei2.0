//
//  LFShareFoodiePicViewController.swift
//  Lefoodie
//
//  Created by Manishi on 1/3/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFShareFoodiePicViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var sharePhotoTableView: UITableView!
    var navController: UINavigationController!
    var postImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postBtn.setTitleColor(UIColor.appTheamColor(), for: .normal)
        
        let nibSharePost = UINib(nibName: "LFSharePostTableViewCell", bundle: nil)
        self.sharePhotoTableView.register(nibSharePost, forCellReuseIdentifier: "LFSharePostTableViewCell")
        
        
        let nibChooseLocation = UINib(nibName: "LFChooseLocationTableViewCell", bundle: nil)
        self.sharePhotoTableView.register(nibChooseLocation, forCellReuseIdentifier: "LFChooseLocationTableViewCell")
        
        
        let nibSocialShare = UINib(nibName: "LFSocialShareTableViewCell", bundle: nil)
        self.sharePhotoTableView.register(nibSocialShare, forCellReuseIdentifier: "LFSocialShareTableViewCell")
        
        
    }

    //Tableview Delegate and Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cellSharePost = tableView.dequeueReusableCell(withIdentifier: "LFSharePostTableViewCell", for: indexPath)as? LFSharePostTableViewCell
            cellSharePost?.sharedPic.image = postImage
            return cellSharePost!
            
        }else if indexPath.section == 1{
            let cellChooseLocation = tableView.dequeueReusableCell(withIdentifier: "LFChooseLocationTableViewCell", for: indexPath)as? LFChooseLocationTableViewCell
            return cellChooseLocation!
            
        }else if indexPath.section == 2{
            let cellSocialShare = tableView.dequeueReusableCell(withIdentifier: "LFSocialShareTableViewCell", for: indexPath)as? LFSocialShareTableViewCell
            return cellSocialShare!
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 120
        }else if indexPath.section == 1{
            return 43
        }else{
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
      if section == 1{
            return 30
        }else if section == 2{
            return 70
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section == 2{
            
            let v = view as! UITableViewHeaderFooterView
            let button = UIButton(type: .system) // let preferred over var here
            button.frame = CGRect(x: v.frame.size.width/2 - 100, y:10 , width: 200, height: 45)
            button.backgroundColor = UIColor.appTheamColor()
            button.setTitle("Choose Another Location", for: UIControlState.normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.cornerRadius = 3
            button.addTarget(self, action: #selector(chooseLocation), for: UIControlEvents.touchUpInside)
            v.addSubview(button)
        
        }
    }
    
    func chooseLocation(){
        print("btn clicked")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.sharePhotoTableView.endEditing(true)
    }
    @IBAction func postBtnAction(_ sender: Any) {
        
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.navController?.popToRootViewController(animated: true)
    }
    
}
