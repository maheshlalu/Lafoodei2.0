//
//  LFShooseAnotherLocation.swift
//  Lefoodie
//
//  Created by SRINIVASULU on 31/01/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFShooseAnotherLocation: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    typealias typeCompletionHandler = () -> ()
    var completion : typeCompletionHandler = {}

    override func viewDidLoad() {
      
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "CellLocation")
        
        Cell?.textLabel?.text = "Location Title"
        Cell?.textLabel?.textColor = UIColor.gray
       
        Cell?.detailTextLabel?.text = "Descrption for laocation"
         Cell?.detailTextLabel?.textColor = UIColor.lightGray
        
        return Cell!
        
        
       
    }
  
    //MARK : Top navigation actions
    
    @IBAction func Btn_CancelBtnTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            self.completion()
        })
    }

    func dismissVCCompletion(completionHandler: @escaping typeCompletionHandler) {
        self.completion = completionHandler
    }
    
    @IBAction func Btn_LocationBtnTapped(_ sender: Any) {
        
      //  performSegue(withIdentifier: "Back_Location", sender: self)

        self.dismiss(animated: true, completion: {
            self.completion()
        })
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller. Back_Location
        
        if segue.identifier == "Back_Location" {
            let controller = segue.destination as! LFShareFoodiePicViewController
            //controller.Str_KeyValues = "3"
        }
        
        
        
    }
    

}
