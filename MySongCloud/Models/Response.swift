//
//  Response.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 8/1/22.
//

import Foundation

struct Response: Decodable {
    
    var id: UUID = UUID()
    var songs: [Song] = []
    
    enum CodingKeys: String, CodingKey{
        
        case items
        
    }
    
    init (from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //decode json into Array of songs
        self.songs = try container.decode([Song].self, forKey: .items)
    }
}
