//
//  AppDelegate.swift
//  Chat
//
//  Created by Liuqing Du on 15/03/2015.
//  Copyright (c) 2015 JuneDesign. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate {

    var window: UIWindow?
    
    // stream
    var xs: XMPPStream?
    // is server on
    var isOpen = false
    // password
    var pwd = ""
    
    // status proxy
    var statusProxy: StatusProtocol?
    
    // message proxy
    var messageProxy: MessageProtocol?
    
    // get message
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        
        
        // if is chat message
        if message.isChatMessage() {
            var msg = BuddyMessage()
            
            // is comosing
            if message.elementForName("composing") != nil {
                msg.isComposing = true
                
            }
            
            // offline message
            if message.elementForName("delay") != nil {
                msg.isDelay = true
            }
            
            // body
            if let body = message.elementForName("body") {
                msg.body = body.stringValue()
            }
            
            // user name with domain
            msg.from = message.from().user + "@" + message.from().domain
            
            messageProxy?.newMsg(msg)
            
        }
        
        
    }
    
    // get status
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        // my user name
        let myUser = sender.myJID.user
        
        // buddy user name
        let buddy = presence.from().user
        
        // domain
        let domain = presence.from().domain
        
        // status type
        let type  = presence.type()
        
        // if status is not mine
        if (buddy != myUser) {
            // status
            var status = Status()
            // user name with domain
            status.name = buddy + "@" + domain
            
            // online
            if type == "available" {
                status.isOnline = true
                statusProxy?.isOn(status)
                
            } else if type == "unavailable" {
                //status.isOnline = false
                statusProxy?.isOff(status)
            }
        }
    }
    
    // connected
    func xmppStreamDidConnect(sender: XMPPStream!) {
        isOpen = true
        
        let register = NSUserDefaults.standardUserDefaults().boolForKey("chatRegister")
        if register {
            //println("register for \(xs!.myJID.user) at \(xs!.myJID.domain)")
            
            if (!xs!.registerWithPassword(pwd, error: nil)) {
                UIAlertView(title: "Error", message: "Error when register", delegate: nil, cancelButtonTitle: "OK")
            }
        } else {
            // authenticate password
            xs!.authenticateWithPassword(pwd, error: nil)
            
        }
        
    }
    
    // registered
    func xmppStreamDidRegister(sender: XMPPStream!) {
        //println("registered with \(sender.myJID.user)")
        
        UIAlertView(title: "Registered", message: "Registered with \(sender.myJID.user)", delegate: nil, cancelButtonTitle: "OK").show()
        
        //NSUserDefaults.standardUserDefaults().setBool(false, forKey: "chatRegister")
        
        //self.connect()
        
    }
    
    func xmppStream(sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        UIAlertView(title: "Error", message: error.stringValue(), delegate: nil, cancelButtonTitle: "OK").show()
        //println(error)
    }
    
    // authenticated
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        // go online
        goOnline()
    }
    
    // create stream
    func buildStream() {
        xs = XMPPStream()
        xs?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        
    }
    
    // send online
    func goOnline(){
        var p = XMPPPresence(type: "available");
        
        xs?.sendElement(p)
    }
    
    // send offline
    func goOffline(){
        var p = XMPPPresence(type: "unavailable");
        
        xs?.sendElement(p)
    }
    
    // connect sever
    func connect() {
        buildStream()
        
        // is connected
        if xs!.isConnected() {
            //println("connected")
            self.disConnect()
            //return true
            
        }
        
        let user = NSUserDefaults.standardUserDefaults().stringForKey("chatID")
        let passwd = NSUserDefaults.standardUserDefaults().stringForKey("chatPwd")
        let server = NSUserDefaults.standardUserDefaults().stringForKey("chatServer")
        let register = NSUserDefaults.standardUserDefaults().boolForKey("chatRegister")
        
        if (user != nil && passwd != nil) {
            // username
            xs!.myJID = XMPPJID.jidWithString(user!)
            
            // server
            xs!.hostName = server!
            
            // password
            pwd = passwd!
            
            xs!.connectWithTimeout(5000, error: nil)
            
            //println("connecting")
            
        }
        
    }
    
    // disconnect
    func disConnect() {
        if xs != nil {
            if xs!.isConnected(){
                goOffline()
                xs!.disconnect()
                xs = nil
                //println("disconnect")
                
            }
        }
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

