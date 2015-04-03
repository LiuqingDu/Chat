//
//  MessageProtocol.swift
//  Chat
//
//  Created by Liuqing Du on 15/03/2015.
//  Copyright (c) 2015 JuneDesign. All rights reserved.
//

import Foundation

// message proxy protocol
protocol MessageProtocol {
    func newMsg(aMsg: BuddyMessage)
    
}