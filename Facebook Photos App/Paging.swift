//
//  Paging.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/13/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import Foundation
import ObjectMapper

class Paging: Mappable {
    var previous: String!
    var next: String!
    
    required init?(_ map: ObjectMapper.Map) {
        mapping(map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        previous <- map["previous"]
        previous = (previous ?? "")
        
        next <- map["next"]
        next = (next ?? "")
    }
}
