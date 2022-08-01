//
//  SongListViewModel.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/31/22.
//

import Foundation

class SongListViewModel: ObservableObject{
    static var API_KEY = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
    static var keyword = "industry%20baby"
    var API_URL = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=25&q=\(keyword)&key=\(API_KEY)"
    
    init(){
        self.getSongs()
    }
    
    func getSongs(){
        let url = URL(string: API_URL)
        
        guard url != nil else {return}
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, err) in
            
            if err != nil || data == nil {
                return
            }
            
            //parse data into song objects
            do{
                
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(Response.self, from: data!)
                
                dump(response)
                
            }catch{
                
                print("Error: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
}
