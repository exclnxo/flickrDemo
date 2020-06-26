//
//  PhotoModel.swift
//  photoDemo
//
//  Created by 徐常璿 on 2020/6/25.
//  Copyright © 2020 Eric Hsu. All rights reserved.
//

import Foundation

struct FlickerModel: Codable {
    var photos: FlickrPhtoModel
    var stat: String
}

struct FlickrPhtoModel: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [PhotoModel]
}

struct PhotoModel: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
    
    var imageUrl: URL {
       return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
    
}
