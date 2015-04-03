//
//  BuddyMessage.swift
//  Chat
//
//  Created by Liuqing Du on 15/03/2015.
//  Copyright (c) 2015 JuneDesign. All rights reserved.
//

import Foundation

// Buddy Message Struct
struct BuddyMessage {
    //properties and methods
    var body: String = ""
    var from: String = ""
    var isComposing: Bool = false
    var isDelay: Bool = false
    var isMe: Bool = false
    
}

/*
// find index to remove
func findRemoveIndex(value: String, aArray: [BuddyMessage]) -> [Int] {
    var indexArray = [Int]()
    var correctArray = [Int]()
    
    // find index
    for (index, _) in enumerate(aArray) {
        if (value == aArray[index].from) {
            // if find value, save index
            indexArray.append(index)
            
        }
    }
    
    // get the correct index
    for (index, originIndex) in enumerate(indexArray) {
        // correct index is original - new index
        correctArray.append(originIndex - index)
        
    }
    
    return correctArray
}

func removeValueFromArray(value: String, inout aArray: [BuddyMessage]) {
    var correctArray = [Int]()
    
    correctArray = findRemoveIndex(value, aArray)
    
    // remove value
    for index in correctArray {
        aArray.removeAtIndex(index)
    }
    
}
*/