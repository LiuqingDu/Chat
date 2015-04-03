//
//  StatusProtocol.swift
//  Chat
//
//  Created by Liuqing Du on 15/03/2015.
//  Copyright (c) 2015 JuneDesign. All rights reserved.
//

import Foundation

// status proxy protocol
protocol StatusProtocol {
    func isOn(status: Status)
    func isOff(status: Status)
    func meOff()
    
}