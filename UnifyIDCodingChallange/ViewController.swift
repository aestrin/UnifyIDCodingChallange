//
//  ViewController.swift
//  UnifyIDCodingChallange
//
//  Created by Adam Estrin on 9/20/17.
//  Copyright © 2017 Adam Estrin. All rights reserved.
//

import UIKit

class ViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {

    @IBOutlet weak var loginButton: UIButton!
    
    var timer : Timer!
    var picturesCaptured = 0
    var pictures = [UIImage]()
    
    //Login Keys
    struct KeychainConfiguration {
        static let serviceName = "TouchMeIn"
        static let accessGroup: String? = nil
    }
    
    //Change these here after taking pictures to see that the keychain will fail and not allow access
    let USERNAME = "User"
    let PASSWORD = "password3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraDelegate = self
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = false
        audioEnabled = false
        defaultCamera = .front
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let hasPictures = UserDefaults.standard.bool(forKey: "hasTakenPictures")
        if hasPictures {
            loginButton.isHidden = false
        } else {
            loginButton.isHidden = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        print("Took photo \(picturesCaptured)/10: \(photo)")
        pictures.append(photo)
    }

    @IBAction func capture(_ sender: UIButton) {
        self.timer = Timer.scheduledTimer(timeInterval: 0.5,
                                        target:self,
                                        selector:#selector(self.capturePicture),
                                        userInfo:nil,
                                        repeats:true)
    }
    
    func capturePicture() {
        
        takePhoto()
        
        if(picturesCaptured == 10) {
            self.timer.invalidate()
            
            do {
                
                // This is a new account, create a new keychain item with the account name.
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: USERNAME,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                
                // Save the password for the new item.
                try passwordItem.savePassword(PASSWORD)
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
            
            UserDefaults.standard.set(true, forKey: "hasTakenPictures")
            
            
            let alertView = UIAlertController(title: "Picture Taken",
                                              message: "Pictures were taken and protected with the username: \(USERNAME) and password: \(PASSWORD)",
                preferredStyle: .alert)
            
            
            let viewAction = UIAlertAction(title: "View", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "pictureSegue", sender: nil)
            })
            
            alertView.addAction(viewAction)
            present(alertView, animated: true, completion: nil)
        }
        
        picturesCaptured += 1
    }
    
    
    @IBAction func login(_ sender: AnyObject) {
        if checkLogin(username: USERNAME, password: PASSWORD) {
            performSegue(withIdentifier: "pictureSegue", sender: self)
        } else {
            
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "Wrong username or password.",
                                              preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true, completion: nil)
        }
    }
    
    func checkLogin(username: String, password: String) -> Bool {
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        }
        catch {
            fatalError("Error reading password from keychain - \(error)")
        }
        
        return false
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "pictureSegue") {
            if let collectionView = segue.destination as? PictureTableViewController {
                collectionView.pictures = self.pictures
            }
        }
    }
}

