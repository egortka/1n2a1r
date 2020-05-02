//
//  ServerData.swift
//  1n2a1r
//
//  Created by Egor Tkachenko on 29/04/2020.
//  Copyright © 2020 ET. All rights reserved.
//

import Foundation

class ServerData {
    
    // MARK: - Properties
    
    private var jsonData: [String: String]?
    
    var buttons: [RespectButton]? = []
    
    // MARK: - Inityandex_money
    init(requestUrlString: String) {
        
        getJSON(urlToRequest: requestUrlString)
    }
    
    //MARK: - Methods
    func getJSON(urlToRequest: String) {
        if let url = URL(string: urlToRequest) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        self.getButtons(jsonString: jsonString)
//                        self.jsonData = jsonString.convertToDictionary()
//                        self.initButtons()
                    }
                }
            }.resume()
        }
    }
    
    func getButtons(jsonString: String) {
        let strings = jsonString.split(separator: ",")
        print(strings)
        for item in strings {
            let data = item.components(separatedBy: ": ")
            if data.count > 1 {
                let key = String(data[0]).stripped.removingLeadingSpaces()
                print(key)
                let url = String(data[1]).stripped.removingLeadingSpaces()
                print(String(url))
                let button = RespectButton(trackName: key, trackUrl: String(url))
                self.buttons?.append(button)
            }
        }
    }
}
