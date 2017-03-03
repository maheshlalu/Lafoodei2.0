//
//  LFShooseAnotherLocation.swift
//  Lefoodie
//
//  Created by SRINIVASULU on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFShooseAnotherLocation: UIViewController {
    
    @IBOutlet weak var chooseLocationTblView: UITableView!
    var resturantsList = [Restaurants]()

    override func viewDidLoad() {
        super.viewDidLoad()
        chooseLocationTblView.delegate = self
        chooseLocationTblView.dataSource = self
    }
    
    //MARK : Top navigation actions
    
    @IBAction func Btn_CancelBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Btn_LocationBtnTapped(_ sender: Any) {

    }
}

extension LFShooseAnotherLocation: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resturantsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "CellLocation")
        let resturantData : Restaurants = self.resturantsList[indexPath.row]
        Cell?.textLabel?.text = resturantData.restaurantName
        Cell?.textLabel?.textColor = UIColor.gray
       // Cell?.detailTextLabel?.text = "Descrption for laocation"
        Cell?.detailTextLabel?.textColor = UIColor.lightGray
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resturantData : Restaurants = self.resturantsList[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
}

