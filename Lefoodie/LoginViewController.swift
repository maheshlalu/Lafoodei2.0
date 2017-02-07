//
//  ViewController.swift
//  Lefoodie
//
//  Created by Rama kuppa on 29/12/16.
//  Copyright © 2016 NOVO. All rights reserved.
//

import UIKit
import GoogleSignIn
import  Google
import FBSDKCoreKit
import FBSDKLoginKit
import MagicalRecord
import CoreData
class LoginViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {
    var facebookResponseDict: NSDictionary! = nil
    var googleResponseDict: NSDictionary! = nil

    
    @IBAction func emailSignupBtnAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFSignUpViewController")as? LFSignUpViewController
        self.navigationController?.pushViewController(storyboard!, animated: true)
    }
    @IBOutlet weak var googleLoginBtn: UIButton!
    @IBOutlet weak var facebookLoginBtn: UIButton!
   
let signIn = GIDSignIn.sharedInstance()
    
    //MARK: Google Signin
    
    @IBAction func googleSignInBtnAction(_ sender: UIButton) {
        
        signIn?.signOut()
        signIn?.clientID = "803211070847-552fk8b896jocpef952a6gg8abgk2q8m.apps.googleusercontent.com"
        signIn?.signIn()

    }
    @IBOutlet weak var signUpEmailBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.facebookLoginBtn.isHidden = true
        
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
        
        signIn?.shouldFetchBasicProfile = true
        signIn?.delegate = self;
        signIn?.uiDelegate = self
        self.setUpDelegatesForGoogle()
      
        self.navigationController?.isNavigationBarHidden = false

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//    func setUpNavigationBar()
//    {
//        self.title = "Login"
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSForegroundColorAttributeName: UIColor.white,
//            NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 20)!
//        ]
//        
//        let btn1 = UIButton(type: .custom)
//        btn1.setImage(UIImage(named: "back-120"), for: .normal)
//        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btn1.addTarget(self, action: #selector(LoginViewController.), for: .touchUpInside)
//        let barButton = UIBarButtonItem(customView: btn1)
//        barButton.tintColor = UIColor.white
//        self.navigationItem.leftBarButtonItem  = barButton
//    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpDelegatesForGoogle()
    {
        signIn?.shouldFetchBasicProfile = true
        signIn?.delegate = self
        signIn?.uiDelegate = self
        
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations on signed in user here.
        if (error == nil) {
            var firstName = ""
            var lastName = ""
            // let userId = user.userID
            var profilePic = ""
            var email = ""
            
            CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let url = NSURL(string:  "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(user.authentication.accessToken!)")
            let session = URLSession.shared
            session.dataTask(with: url! as URL) {(data, response, error) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                do {
                    let userData = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject]
                    print(userData)
                    
                    firstName = userData!["given_name"] as! String
                    lastName = userData!["family_name"] as! String
                    profilePic = userData!["picture"] as! String
                    email = userData!["email"] as! String
                    
                    print("\(email)\(firstName)\(lastName)\(profilePic)")
                    self.googleResponseDict = userData as NSDictionary!
                    MagicalRecord.save({ (localContext) in
                        
                        UserProfile.mr_truncateAll(in: localContext)
                    })
                    CX_SocialIntegration.sharedInstance.applicationRegisterWithGooglePlus(userDataDic: self.googleResponseDict, completion: { (isRegistred) in
                        CXDataService.sharedInstance.hideLoader()
                        
                        self.showAlert()
                        
                    })

                } catch {
                    NSLog("Account Information could not be loaded")
                }
                
                }.resume()
        }
            
        else {
            //Login Failed
            NSLog("login failed")
            return
            
        }
        
    }
    
    //mark:- facebook integration
    
    
    func goToTabBar(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.navigateToTabBar()
    }
    
    @IBAction func facebookBtnAction(_ sender: UIButton) {
        
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
                        self.getFBUserData()
                        fbLoginManager.logOut()
                        
                    }
                }
            }
        }
        
        
    }
   //MARK: GetFacebook Userdata
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.facebookResponseDict = result as! [String : AnyObject] as NSDictionary!
                    print(result!)
                    print(self.facebookResponseDict)
                    //For removing existing user from CoreData
                    MagicalRecord.save({ (localContext) in
                        
                        UserProfile.mr_truncateAll(in: localContext)
                    })
                    
                    CX_SocialIntegration.sharedInstance.applicationRegisterWithFaceBook(userDataDic: self.facebookResponseDict, completion: { (isRegistred) in
                        CXDataService.sharedInstance.hideLoader()
                        print(isRegistred)
                        self.showAlert()
                        
                    })
                    
                    
                    
                }
                else {
                    CXDataService.sharedInstance.hideLoader()
                    return
                }
            })
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func showAlert()
    {
        let alertController = UIAlertController(title: "LeFoodie", message: "You are Successfully Logged in", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.navigateToTabBar()
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    @IBAction func btnSigninButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LFSignInViewController")as? LFSignInViewController
        self.navigationController?.pushViewController(storyboard!, animated: true)
        
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
}

