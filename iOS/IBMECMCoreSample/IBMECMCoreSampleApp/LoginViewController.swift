/*
* © Copyright IBM Corp. 2015
*/

import Foundation
import UIKit

import IBMECMCore

class LoginViewController : UIViewController {
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var navigatorUrlTxt: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var ibmecmapp: IBMECMApplication?
    
    @IBAction func submitTapped(sender: UIButton) {
        println("username: \(usernameTxt.text)")
        println("password: you kidding?")
        println("username: \(navigatorUrlTxt.text)")
        
        if let user: String = usernameTxt.text, password = passwordTxt.text, url = navigatorUrlTxt.text {
            if(count(user) < 1 || count(password) < 1 || count(url) < 1) {
                Util.showError("Error", message: "Username, password and navigator url are all required for login.", vc: self)
                
                return
            }
            
            /* let's login */
            ibmecmapp = IBMECMFactory.sharedInstance.getApplication(url)
            
            ibmecmapp!.login(user, password: password, onComplete: {
                [weak self, weak ibmecmapp] (error: NSError?) -> Void in
                
                if let weakSelf = self {
                    if let loginError = error {
                        // login failed
                        var title = "Login error"
                        if let detailTitle = loginError.localizedFailureReason {
                            title = detailTitle
                        }
                        
                        var message = "Enter the right username/password/url and try again"
                        if let detailMessage = loginError.localizedRecoverySuggestion {
                            message = detailMessage
                        }
                        
                        if(IBMECMFactory.sharedInstance.getCurrentRepository(ibmecmapp!) == nil) {
                            Util.showError(title, message: message, vc: weakSelf)
                        
                            return
                        }
                    }
                    
                    if let weakApp = ibmecmapp {                        
                        weakSelf.performSegueWithIdentifier("transitionToMainMenu", sender: weakSelf)
                    }
                }
                })
        } else {
            Util.showError("Error", message: "Username, password and navigator url are all required for login.", vc: self)
        }
    }
        
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        println("unwindSegue: LoginViewController")
        
        if let svc = segue.sourceViewController as? UIViewController {
            self.ibmecmapp?.logoff(nil)
            
            svc.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}