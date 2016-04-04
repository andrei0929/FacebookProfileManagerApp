//
//  Image.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/1/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import Foundation
import ObjectMapper

class Image: Mappable {
    var height: Int!
    var width: Int!
    var source: String!
    
    required init?(_ map: ObjectMapper.Map) {
        mapping(map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        height <- map["height"]
        width <- map["width"]
        source <- map["source"]
    }
}
