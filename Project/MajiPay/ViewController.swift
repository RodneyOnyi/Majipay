//
//  ViewController.swift
//  MajiPay
//
//  Created by Apple on 31/03/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var txtMeterNo: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let backItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ViewController.logout))
        backItem.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = backItem
        
    }
    
    func logout(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutViewController")
        self.navigationController?.viewControllers = [vc!]
    }
  
    @IBAction func btnSearch(_ sender: UIButton) {
      
        let meterNumber = txtMeterNo.text;
        
        self.view.endEditing(true)
        if((meterNumber?.isEmpty)!){
            LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Please fill all fields");
        }
        else if(Reachability.isConnectedToNetwork() == false){
            DispatchQueue.main.async {
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "No internet Connection")
                
            }
        }
        else{
        
        let finalURL = "\(URL_BASE)?action=getMeter"
        
       let myParameters = ["meter_number": meterNumber!]
        
        DispatchQueue.main.async {
            RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
            
        }
        request(finalURL, method: .get, parameters: myParameters).responseJSON { response in
            DispatchQueue.main.async {
                RappleActivityIndicatorView.stopAnimating()
                
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                print("Error: \(response.result.error!)")
                return
            }
            print("value of json is \(json)")
            
            // get and print the title
            guard let status = json["status"] as? String else {
                print("Could not get status title from JSON")
                return
            }
            
           if(status != "success"){
                DispatchQueue.main.async {
                
                    LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Meter Number not found. Please input another one")
                    self.txtMeterNo.text = ""
                }
                
            }else{
                
               guard let meterData =  json["data"] as? NSArray else{
                    return
                }
            
            if(meterData.count >= 1){
                var compliance = ""
                var meter_number = ""
                var owner_name = ""
                var meter_reading = ""
                
              for item in meterData{
                    if let compliance1 = (item as AnyObject).value(forKey:"compliance") as? String {
                        compliance = compliance1
                    }
                    if let meter_number1 = (item as AnyObject).value(forKey:"meter_number") as? String {
                        meter_number = meter_number1
                    }
                    if let owner_name1 = (item as AnyObject).value(forKey:"owner_name") as? String {
                       owner_name = owner_name1
                    }
                    if let meter_reading1 = (item as AnyObject).value(forKey:"meter_reading") as? String {
                       meter_reading = meter_reading1
                    }
                }
                
                
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MeterUpdateViewController") as! MeterUpdateViewController
                
                secondViewController.compliance = compliance
                secondViewController.meter_number = meter_number
                secondViewController.owner_name = owner_name
                secondViewController.meter_reading = meter_reading
                self.navigationController?.pushViewController(secondViewController, animated: true)
                
                
            }else{
              
            }
            
            
            }
            
        }
            
        }
    }
    
    
    
    

}

