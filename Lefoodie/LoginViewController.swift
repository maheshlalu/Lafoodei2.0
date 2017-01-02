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



class LoginViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {
    var facebookResponseDict: NSDictionary! = nil

    @IBOutlet weak var googleLoginBtn: UIButton!
    @IBOutlet weak var facebookLoginBtn: UIButton!
   
let signIn = GIDSignIn.sharedInstance()
    
    @IBAction func googleSignInBtnAction(_ sender: UIButton) {
        
        signIn?.signOut()
        signIn?.clientID = "803211070847-552fk8b896jocpef952a6gg8abgk2q8m.apps.googleusercontent.com"
        signIn?.signIn()

    }
    @IBOutlet weak var signUpEmailBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
        
        signIn?.shouldFetchBasicProfile = true
        signIn?.delegate = self;
        signIn?.uiDelegate = self
      
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
    @IBAction func facebookBtnAction(_ sender: UIButton) {
        
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                        
                    }
                }
            }
            else {
                print(error?.localizedDescription)
            }
        }

        
        
    }
   
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.facebookResponseDict = result as! [String : AnyObject] as NSDictionary!
                    print(result!)
                    print(self.facebookResponseDict)
//                    CX_SocialIntegration.sharedInstance.applicationRegisterWithFaceBook(userDataDic: self.facebookResponseDict, completion: { (isRegistred) in
//    
//                        
//                    })
                    
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
}

