//
//  MainRouter.swift
//  AppExtention
//
//  Created by  inna on 04/03/2021.
//

import Foundation


open class DFetcher {

    
 static let sheredIdentifier: String =  "group.test.inna.AppExtention"

 open  class func fetchedSharedData() -> String {
    if let shereData = UserDefaults(suiteName: sheredIdentifier) {
        
        return shereData.string(forKey: "first") ?? ""
    }
  
        return "first"
  }
}
