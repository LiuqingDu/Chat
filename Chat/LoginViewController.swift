//
//  LoginViewController.swift
//  Chat
//
//  Created by Liuqing Du on 15/03/2015.
//  Copyright (c) 2015 JuneDesign. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var registerSwitch: UISwitch!
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var serverTF: UITextField!
    
    @IBAction func register(sender: UIButton) {
        
        NSUserDefaults.standardUserDefaults().setObject(userTF.text, forKey: "chatID")
        NSUserDefaults.standardUserDefaults().setObject(pwdTF.text, forKey: "chatPwd")
        NSUserDefaults.standardUserDefaults().setObject(serverTF.text, forKey: "chatServer")
        
        // auto login
        NSUserDefaults.standardUserDefaults().setBool(self.autoLoginSwitch.on, forKey: "chatAutoLogin")
        
        // register
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "chatRegister")
        
        // set user
        NSUserDefaults.standardUserDefaults().synchronize()
        
        delegate().disConnect()
        
        delegate().connect()
        
    }
    
    // require login
    var requireLogin = false
    
    // get delegate
    func delegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender as UIBarButtonItem == self.doneButton {
            
            NSUserDefaults.standardUserDefaults().setObject(userTF.text, forKey: "chatID")
            NSUserDefaults.standardUserDefaults().setObject(pwdTF.text, forKey: "chatPwd")
            NSUserDefaults.standardUserDefaults().setObject(serverTF.text, forKey: "chatServer")
            
            // auto login
            NSUserDefaults.standardUserDefaults().setBool(self.autoLoginSwitch.on, forKey: "chatAutoLogin")
            
            // register
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "chatRegister")
            
            // set user
            NSUserDefaults.standardUserDefaults().synchronize()
            
            // require login
            requireLogin = true
            
            //println("require login")
        
        }
    }

}
