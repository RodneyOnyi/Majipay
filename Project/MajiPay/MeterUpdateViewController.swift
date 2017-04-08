//
//  MeterUpdateViewController.swift
//  MajiPay
//
//  Created by Apple on 31/03/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD
import CoreLocation

class MeterUpdateViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    
    @IBOutlet weak var txtMeterNumber: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtLastReading: UILabel!
    @IBOutlet weak var txtCompliance: UITextField!
    
    @IBOutlet weak var txtNewMeterReading: UITextField!
   
    var compliance:String?
    var meter_number:String?
    var owner_name:String?
    var meter_reading:String?
    
    var mylongitude = ""
    var mylatitude = ""
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let newMeterReading = txtNewMeterReading.text;
        let userCompliance = txtCompliance.text;
       
        if((userCompliance?.isEmpty)!){
            LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Please fill compliance");
        }
        else if((newMeterReading?.isEmpty)!){
            LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Please fill meter reading");
        }
        else if(((Int(newMeterReading!)! - Int(meter_reading!)!) < 1)){
            LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Please fill the correct meter reading");
        }
            
        else if(Reachability.isConnectedToNetwork() == false){
            DispatchQueue.main.async {
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "No internet Connection")
            }
        }
        else if(mylatitude.characters.count < 1){
            DispatchQueue.main.async {
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Please turn on your location and try again")
            }
        }
            
        else{
            let defaults = UserDefaults.standard
            let user_id = defaults.string(forKey: "user_id")
          
            let myParameters = ["meter_number": meter_number!, "meter_reading": newMeterReading!,"user_id":user_id!,"longitude": mylongitude,"latitude": mylatitude,"compliance":userCompliance!]
            
            DispatchQueue.main.async {
                RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
            }
            request("\(URL_BASE)?action=updateMeterReadings", method: .get, parameters: myParameters).responseJSON { response in
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
                        LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Update failed")
                    }
                }else{
                    let message: String = json["message"] as! String
                    DispatchQueue.main.async {
                       
                        // Create the alert controller
                        let alertController = UIAlertController(title: "Maji Pay", message: message, preferredStyle: .alert)
                        // Create the actions
                        let okAction = UIAlertAction(title: "Home", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                           
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
                            self.navigationController?.viewControllers = [vc!]
                            
                        }
                     
                        // Add the actions
                        alertController.addAction(okAction)                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    }
                    
                }
            }
        }
        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtNewMeterReading.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineMyCurrentLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(MeterUpdateViewController.logout))
        backItem.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = backItem
        
        txtMeterNumber.text = meter_number
        txtName.text = owner_name
        txtLastReading.text = meter_reading
        
      }
    
    func logout(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SplashScreenViewController")
        self.navigationController?.viewControllers = [vc!]
    }
    
    
    
    
    
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
        
        mylatitude = "\(userLocation.coordinate.latitude)"
        mylongitude = "\(userLocation.coordinate.longitude)"
        
        print("user_latitude = \(userLocation.coordinate.latitude)")
        print("user_longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

 

}
