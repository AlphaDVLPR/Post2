//
//  Post.swift
//  Post
//
//  Created by AlphaDVLPR on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

//THIS IS THE STRUCT CLASS

//WE ARE CALLING IN CODABLE TO BE ALLOWED TO DECODE INFORMATION

struct Post : Codable {
    
    //THESE ARE THE VARIABLES TO POST
    
    let text: String
    let timestamp: TimeInterval
    let username: String
    
    //THIS IS THE INITIALIZER
    
    init(text: String, username: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        
        //THESE ARE THE KEY'S FROM THE JSON DICTIONARY
        
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
    
}
