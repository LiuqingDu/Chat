//
//  BuddyListViewController.swift
//  Chat
//
//  Created by Liuqing Du on 15/03/2015.
//  Copyright (c) 2015 JuneDesign. All rights reserved.
//

import UIKit

class BuddyListViewController: UITableViewController, StatusProtocol, MessageProtocol {
    
    @IBAction func loginButton(sender: UIBarButtonItem) {
        // set image of status
        if logged {
            // log out
            logout()
            
            // set image
            //sender.image = UIImage(named: "offline")
            
        } else {
            // log in
            login()
            
            //set image
            //sender.title = "Online"
            //sender.image = UIImage(named: "online")
            
        }
    }
    @IBOutlet weak var myStatus: UIBarButtonItem!
    
    // unread message List
    var unreadList = [BuddyMessage]()
    
    // buddy status list
    var statusList = [Status]()
    
    // logged
    var logged = false
    
    // name of buddy
    var currentBuddyName = ""
    
    // me offline
    func meOff() {
        self.logout()
        
    }
    
    // receive message
    func newMsg(aMsg: BuddyMessage) {
        // if body is not empty, add to message list
        if (!aMsg.body.isEmpty) {
            
            // add to message list
            unreadList.append(aMsg)
            
            // refresh list
            self.tableView.reloadData()
        }
        
    }
    
    // online
    func isOn(status: Status) {
        // find status
        for (index, oldstatus) in enumerate(statusList) {
            
            // if find old status
            if (status.name == oldstatus.name) {
                
                // delete old status
                statusList.removeAtIndex(index)
                break
                
            }
            
        }
        
        // add status
        statusList.append(status)
        
        // refresh tableview
        self.tableView.reloadData()
    }
    
    // offline
    func isOff(status: Status) {
        // find status
        for (index, oldstatus) in enumerate(statusList) {
            
            // if find old status
            if (status.name == oldstatus.name) {
                
                // delete old status
                statusList[index].isOnline = false
                break
                
            }
            
        }
        
        // refresh tableview
        self.tableView.reloadData()
    }
    
    // get delegate
    func delegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
        
    }
    
    // login
    func login() {
        // reset list
        unreadList.removeAll(keepCapacity: false)
        statusList.removeAll(keepCapacity: false)
        
        delegate().connect()
        
        // status image
        myStatus.title = "logout"
        //myStatus.image = UIImage(named: "online")
        
        logged = true
        
        // get user name
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("chatID")
        
        // change title
        self.navigationItem.title = myID! + "'s Buddy"
        
        // reset table
        self.tableView.reloadData()
        
    }
    
    // logout
    func logout() {
        // reset list
        unreadList.removeAll(keepCapacity: false)
        statusList.removeAll(keepCapacity: false)
        
        delegate().disConnect()
        
        // status image
        myStatus.title = "login"
        //myStatus.image = UIImage(named: "offline")
        
        logged = false
        
        // reset table
        self.tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // get user name
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("chatID")
        
        // get if auto login
        let autoLogin = NSUserDefaults.standardUserDefaults().boolForKey("chatAutoLogin")
        
        // auto login
        if (myID != nil && autoLogin) {
            self.login()
            
        } else {
            self.performSegueWithIdentifier("toLoginSegue", sender: self)
            
        }
        
        // set status delegate
        delegate().statusProxy = self

    }
    
    override func viewDidAppear(animated: Bool) {
        
        // set message delegate
        delegate().messageProxy = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    // section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
        
    }
    
    // row of table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return statusList.count
        
    }
    
    //  content of cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("buddyListCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        // status of buddy
        let online = statusList[indexPath.row].isOnline
        
        // name of buddy
        let name = statusList[indexPath.row].name
        
        // number of unread
        var unreads = 0
        
        // find number of unread
        for msgs in unreadList {
            if (name == msgs.from) {
                unreads++
            }
        }
        
        // text of cell
        cell.textLabel?.text = name + "(\(unreads))"
        
        // set image
        if online {
            cell.imageView?.image = UIImage(named: "online")
            
        } else {
            cell.imageView?.image = UIImage(named: "offline")
            
        }

        return cell
    }
    
    // select cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // name of buddy
        currentBuddyName = statusList[indexPath.row].name
        
        // go to chat view
        self.performSegueWithIdentifier("toChatSegue", sender: self)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        // if need to chat view
        if (segue.identifier == "toChatSegue") {
            // get destination
            let dest = segue.destinationViewController as ChatViewController
            
            // send current buddy name
            dest.toBuddyName = currentBuddyName
            
            // send unread list
            for msg in unreadList {
                if msg.from == currentBuddyName {
                    // add message
                    dest.messageList.append(msg)
                }
            }
            
            // delete message
            //removeValueFromArray(currentBuddyName, &unreadList)
            
            unreadList = unreadList.filter{$0.from != self.currentBuddyName}
            
            // refresh tableview
            self.tableView.reloadData()
            
        }
    }
    
    @IBAction func unwindToBList(segue: UIStoryboardSegue) {
        // if done
        let source = segue.sourceViewController as LoginViewController
        
        if source.requireLogin {
            // logout if already login
            self.logout()
            
            // login
            self.login()
        }
        
    }

}
