//
//  ChatViewController.swift
//  Chat
//
//  Created by Liuqing Du on 15/03/2015.
//  Copyright (c) 2015 JuneDesign. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController, MessageProtocol {

    @IBAction func composing(sender: UITextField) {
        
        // create xml
        var xmlMessage = DDXMLElement.elementWithName("message") as DDXMLElement
        
        // set xmlMessage
        xmlMessage.addAttributeWithName("to", stringValue: toBuddyName)
        xmlMessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("chatID"))
        
        // set composing
        var composing = DDXMLElement.elementWithName("composing") as DDXMLElement
        composing.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/chatstates")
        
        // add composing
        xmlMessage.addChild(composing)
        
        // send xml
        delegate().xs?.sendElement(xmlMessage)
        
    }
    @IBAction func sendButton(sender: UIBarButtonItem) {
        // get text
        let msgStr = msgTF.text
        
        // if not empty
        if (!msgStr.isEmpty) {
            // create xml
            var xmlMessage = DDXMLElement.elementWithName("message") as DDXMLElement
            
            // set xmlMessage
            xmlMessage.addAttributeWithName("type", stringValue: "chat")
            xmlMessage.addAttributeWithName("to", stringValue: toBuddyName)
            xmlMessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("chatID"))
            
            // set body
            var body = DDXMLElement.elementWithName("body") as DDXMLElement
            body.setStringValue(msgStr)
            
            // add body
            xmlMessage.addChild(body)
            
            // send xml
            delegate().xs?.sendElement(xmlMessage)
            
            // empty text field
            msgTF.text = ""
            
            // save message
            var msg = BuddyMessage()
            
            msg.isMe = true
            msg.body = msgStr
            
            // add to list
            messageList.append(msg)
            
            // refresh tableview
            self.tableView.reloadData()
            
        }
        
    }
    @IBOutlet weak var msgTF: UITextField!
    
    // name of buddy
    var toBuddyName = ""
    
    // message List
    var messageList = [BuddyMessage]()
    
    // receive message
    func newMsg(aMsg: BuddyMessage) {
        
        // if is composing
        if (aMsg.isComposing) {
            
            // change title
            self.navigationItem.title = "\(toBuddyName) is composing"
            
        }else
            
        // if body is not empty, add to message list
        if (!aMsg.body.isEmpty) {
            
            // change title
            self.navigationItem.title = toBuddyName
            
            // add to message list
            messageList.append(aMsg)
            
            // refresh list
            self.tableView.reloadData()
        }
        
    }
    
    // get delegate
    func delegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // set status delegate
        delegate().messageProxy = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return messageList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        // get message
        let msg = messageList[indexPath.row]
        
        // set format
        if (msg.isMe) {
            
            // right, gray
            cell.textLabel?.textAlignment = .Right
            cell.textLabel?.textColor = UIColor.grayColor()
            
        } else {
            
            // left, blue
            cell.textLabel?.textAlignment = .Left
            cell.textLabel?.textColor = UIColor.blueColor()
            
        }
        
        // set text
        cell.textLabel?.text = msg.body

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
