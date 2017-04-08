//
//  LoadingBarViewController.swift
//  Taradi
//
//  Created by Apple on 22/02/2017.
//  Copyright © 2017 Masterpiece. All rights reserved.
//

import UIKit
import CoreData

class LoadingBarViewController {
    
    
    
    static func displayMyAlertMessage(targetVC: UIViewController,userMessage:String)
    {
        let myAlert = UIAlertController(title: "Maji Pay", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        targetVC.present(myAlert, animated: true, completion: nil);
    }
    
    
  
}

