//
//  LogoutViewController.swift
//  MajiPay
//
//  Created by Apple on 31/03/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//


import UIKit

class LogoutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.synchronize();
        
        let splashScreen = self.storyboard?.instantiateViewController(withIdentifier: "SplashScreenViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = splashScreen
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
