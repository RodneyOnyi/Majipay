//
//  SignInViewController.swift
//  MajiPay
//
//  Created by Apple on 31/03/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnLogin(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let userName = txtUsername.text;
        let userPassword = txtPassword.text;
        
        if((userName?.isEmpty)! || (userPassword?.isEmpty)!){
            LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Please fill all fields");
        }
        else if(Reachability.isConnectedToNetwork() == false){
            DispatchQueue.main.async {
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "No internet Connection")
                
            }
        }
        else{
            let myParameters = ["username": userName!, "password": userPassword!]
            DispatchQueue.main.async {
                RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
            }
            request("\(URL_BASE)?action=login", method: .get, parameters: myParameters).responseJSON { response in
                DispatchQueue.main.async {
                    RappleActivityIndicatorView.stopAnimating()
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: AnyObject] else {
                    print("didn't get todo object as JSON from API")
                    print("Error: \(response.result.error!)")
                    return
                }
                // get and print the title
                guard let status = json["status"] as? String else {
                    print("Could not get status title from JSON")
                    return
                }
                print(json)
                if(status != "success"){
                    DispatchQueue.main.async {
                       LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Wrong credentials")
                    }
                }else{
                    let user_id: String = json["user_id"] as! String
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                        UserDefaults.standard.set(user_id, forKey: "user_id");
                        UserDefaults.standard.synchronize();
                       
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
                        self.navigationController?.viewControllers = [vc!]
                        
                    }
                    
                }
            }
        }
        
        
    }

   

}
