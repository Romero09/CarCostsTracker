//
//  LoginView.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 03/10/2018.
//Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import Viperit
import FirebaseAuth
import FirebaseUI

//MARK: LoginView Class
final class LoginView: UserInterface {
    
    override func viewDidLoad() {
        self.title = "Car Costs Tracker Login"
    }
    
    @IBAction func login(_ sender: Any) {
        
        if let authViewController = presenter.signInUser(){
        present(authViewController, animated: true, completion: nil)
        }
        
    }
}

extension LoginView: FUIAuthDelegate{
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        
        if let error = error {
            print(error)
        }
        if let _ = user {
            sharedUserAuth.authorizedUser = Auth.auth()
        }
    }
    
}

//MARK: - LoginView API
extension LoginView: LoginViewApi {
}

// MARK: - LoginView Viper Components API
private extension LoginView {
    var presenter: LoginPresenterApi {
        return _presenter as! LoginPresenterApi
    }
    var displayData: LoginDisplayData {
        return _displayData as! LoginDisplayData
    }
}
