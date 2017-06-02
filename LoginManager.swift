//
//  LoginManager.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/2/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import UIKit

class LoginManager: NSObject {
   
    static func presentLogin(_ controller: UIViewController){
        let alert = UIAlertController(title: "Login", message: "Please Login", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(userfield) in
            userfield.placeholder = "Username - (S- Number)"
         
        })
        
        alert.addTextField(configurationHandler: {(passwordField) in
              passwordField.placeholder = "Password"
            passwordField.isSecureTextEntry = true
        })
        
        let login = UIAlertAction(title: "Login", style: .default, handler: {(action) in
           
           let username = alert.textFields?.first?.text
            
            let password = alert.textFields?.last?.text
            if username != "" && password != ""  {
             let requester = JVRequester()
             requester.delegate = controller as? JVRequestDelegate;
                print("not nil")
             requester.logIn(username!, password: password!)
            } else {
                let error = UIAlertController(title: "No username or password", message: "Please enter both a username and a password", preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in
                    DispatchQueue.main.async(execute: {() in
                        presentLogin(controller)
                    })
                })
                error.addAction(okButton)
              
                DispatchQueue.main.async(execute: {() in
                      controller.present(error, animated: true, completion: nil)
                })
             
            }
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(login)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
}
