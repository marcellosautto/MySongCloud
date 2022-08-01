//
//  JSAPIViewModel.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/31/22.
//

import Foundation
import JavaScriptCore

class JSAPI: ObservableObject {
    var jsContext: JSContext!
    
    init(){
        self.jsContext = JSContext()
        
        // Add an exception handler.
            self.jsContext.exceptionHandler = { context, exception in
                if let exc = exception {
                    print("JS Exception:", exc)
                }
            }
        
        if let jsScriptPath = Bundle.main.path(forResource: "FetchSong", ofType: "js") {
            do{
                
                // Fetch and evaluate the GAPI script.
                let gapiScript = try String(contentsOf: URL(string: "https://apis.google.com/js/api.js")!)
                self.jsContext.evaluateScript(gapiScript)
                
                
                let jsScriptContents = try String(contentsOfFile: jsScriptPath)
                self.jsContext.evaluateScript(jsScriptContents)
                

            }
            catch{
                print("Error loading js file: \(error.localizedDescription)")
            }
        }
        
        //self.authenticate()
        //self.loadClient()
        
    }
    
    func authenticate(){
        if let functionAuthenticate = self.jsContext.objectForKeyedSubscript("authenticate"){
            
            if let response = functionAuthenticate.call(withArguments: nil){
                print(response)
            }
        }
    }
    
    func loadClient(){
        if let functionLoadClient = self.jsContext.objectForKeyedSubscript("loadClient"){
            
            if let response = functionLoadClient.call(withArguments: nil){
                print(response)
            }
        }
    }
    
    func fetchSongByKeyword(keyword: String){
        if let functionFetchSongByKeyword = self.jsContext.objectForKeyedSubscript("fetchSongByKeyword"){
            
            if let response = functionFetchSongByKeyword.call(withArguments: [keyword]){
                print(response.toDictionary())
            }
        }
    }
    
    func helloWorld(){
        if let varHelloWorld = self.jsContext.objectForKeyedSubscript("helloWorld"){
            print(varHelloWorld)
        }
    }
}
