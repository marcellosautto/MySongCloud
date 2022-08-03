//
//  SongListViewModel.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/31/22.
//

import Foundation

class SongListViewModel: ObservableObject{
    static var API_KEY = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
    @Published var response: Response!
    
    init(){
        
    }
    
    func getSongs(search: String){
        
        let search_encoded = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let API_URL = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(search_encoded)&key=\(SongListViewModel.API_KEY)"
        
        
        let url = URL(string: API_URL)
        
        guard url != nil else {return}
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { [weak self] (data, response, err) in
            
            if err != nil || data == nil {
                return
            }
            
            DispatchQueue.main.async {
                do{
                    
                    self?.response = nil
                    let decoder = JSONDecoder()
                    self?.response = try decoder.decode(Response.self, from: data!)
                    
                    
                }catch{
                    
                    print("Error: \(error)")
                }
            }
                
            
        }
        dataTask.resume()
        
    }
    
}

