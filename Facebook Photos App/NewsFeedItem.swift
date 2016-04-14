//
//  NewsFeedItem.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/13/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsFeedItem: Mappable {
    var story: String!
    var message: String!
    var pictureUrl: String!
    var type: String!
    
    required init?(_ map: ObjectMapper.Map) {
        mapping(map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        story <- map["story"]
        story = (story ?? "")
        
        message <- map["message"]
        message = (message ?? "")
        
        pictureUrl <- map["picture"]
        pictureUrl = (pictureUrl ?? "")
        
        type <- map["type"]
    }
}
