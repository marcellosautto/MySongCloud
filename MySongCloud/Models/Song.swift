//
//  Song.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 8/1/22.
//

import Foundation

struct Song: Identifiable, Decodable{
    
    let id: UUID = UUID()
    
    var url: URL
    var title: String
    var thumbnail: URL
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
        let videoId = try idContainer.decode(String.self, forKey: .videoId)
        self.url = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        
        //Parse title
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        
        //parse thumbnail
        let thumbnailContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
        let highContainer = try thumbnailContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .high)
        
        let thumbnail_string = try highContainer.decode(String.self, forKey: .thumbnail)
        self.thumbnail = URL(string: thumbnail_string)!
        
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
