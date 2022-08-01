//
//  Song.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 8/1/22.
//

import Foundation

struct Song: Decodable{
    
    var videoId: String
    var title: String
    var thumbnail: String
    var thumbnail_width: Int
    var thumbnail_height: Int
    
    
    enum CodingKeys: String, CodingKey {
        case snippet
        case thumbnails
        case high
        case resourceId
        case id
        
        case videoId
        case title
        case thumbnail = "url"
        case thumbnail_width = "width"
        case thumbnail_height = "height"
    }
    
    init (from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //look for id key and grab container
        let idContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .id)
        
        //look for snippet key and grab container
        let snippetContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
        
        //Parse videoId
        self.videoId = try idContainer.decode(String.self, forKey: .videoId)
        
        //Parse title
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        
        //parse thumbnail
        let thumbnailContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
        let highContainer = try thumbnailContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .high)
        
        self.thumbnail = try highContainer.decode(String.self, forKey: .thumbnail)
        
        //Parse thumbnail_width
        self.thumbnail_width = try highContainer.decode(Int.self, forKey: .thumbnail_width)
        
        //Parse thumbnail_height
        self.thumbnail_height = try highContainer.decode(Int.self, forKey: .thumbnail_height)
        
        
        
    }
}

struct Thumbnail {
    var url: String
    var width: Int
    var height: Int
}
