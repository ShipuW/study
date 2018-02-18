//
//  BaseModel.swift
//  study
//
//  Created by Shipu Wang on 2/17/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

class BaseModel {
    
    var id : Int16
    
    enum Keys : Int {
        case KeyId
        func toKey() -> String! {
            switch self {
            case .KeyId:
                return "id"
            }
        }
    }
    
    required init(_ dictionary: Dictionary<String, AnyObject>){
        id = Int16((dictionary[Keys.KeyId.toKey()] as? String)!)!
    }
    
    class func ArrayFromDict(dict:Dictionary<String, Any>, keyWord:String) -> (Array<Any>) {
        let array = dict[keyWord];
        return self.ArrayFromArray(array: array as! Array<Any>)
        
    }
    
    class func ArrayFromArray(array:Array<Any>) -> (Array<Any>) {
        
        var resArray: Array<AnyObject> = []
        for item in array {
            let dict = item as? Dictionary<String, AnyObject>
            let object = self.objectFromDictionary(dictionary: dict!)
            resArray.append(object)
        }
        return resArray
        
    }
    
    public class func objectFromDictionary(dictionary: Dictionary<String, AnyObject>) -> Self {
        return self.init(dictionary)
    }
    
    
    
}
