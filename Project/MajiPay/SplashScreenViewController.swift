//
//  SplashScreenViewController.swift
//  MajiPay
//
//  Created by Apple on 31/03/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
       
        if(isUserLoggedIn){
           perform(#selector(SplashScreenViewController.showHome), with: nil, afterDelay: 2)
        }
        else{
            perform(#selector(SplashScreenViewController.showLoginBar), with: nil, afterDelay: 2)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showHome(){
        performSegue(withIdentifier: "showHome", sender: self)
    }
    
    func showLoginBar(){
        performSegue(withIdentifier: "showSignIn", sender: self)
    }
    

}
