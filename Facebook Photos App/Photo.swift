//
//  Photo.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/1/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import Foundation
import ObjectMapper

class Photo : Mappable{
    var description: String?
    var id: String!
    var date: NSDate!
    var images: [Image]!
    
    required init?(_ map: ObjectMapper.Map) {
        mapping(map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        description <- map["name"]
        id <- map["id"]
        var date: String!
        date <- map["created_time"]
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.date = formatter.dateFromString(date)
        images <- map["images"]
    }}