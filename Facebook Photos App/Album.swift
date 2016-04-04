//
//  Album.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/1/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import Foundation
import ObjectMapper

class Album : Mappable{
    var nrOfPhotos: Int!
    var id: String!
    var name: String!
    var photoUrl: String!
    
    required init?(_ map: ObjectMapper.Map) {
        mapping(map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        nrOfPhotos <- map["count"]
        id <- map["id"]
        name <- map["name"]
        photoUrl <- map["picture.data.url"]
    }
}