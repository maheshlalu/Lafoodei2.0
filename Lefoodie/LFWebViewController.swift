//
//  LFWebViewController.swift
//  Lefoodie
//
//  Created by Rambabu Mannam on 22/03/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFWebViewController: UIViewController {


    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backward: UIBarButtonItem!
    @IBOutlet weak var forward: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var stop: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingWebView()
        setUpNavigationBar()
    }
    
    func loadingWebView()
    {
        let urlStr = UserDefaults.standard.value(forKey: "WebViewURLString")
        let url = URL.init(string: urlStr as! String)
        let myRequest = URLRequest.init(url: url!)
        webView.loadRequest(myRequest)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateButtons()
    {
        
        
        self.forward.isEnabled = !self.webView.canGoForward
        self.backward.isEnabled = !self.webView.canGoBack
        self.stop.isEnabled = self.webView.isLoading
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        
    }
    @IBAction func stopAction(_ sender: Any) {
        
    }

    @IBAction func refreshAction(_ sender: Any) {
        
    }
    @IBAction func forwardAction(_ sender: Any) {
        
    }
   
}

extension LFWebViewController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        self.updateButtons()
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.updateButtons()
    }
    
   func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
   {
    self.updateButtons()
   }
}
