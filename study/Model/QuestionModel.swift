//
//  QuestionModel.swift
//  study
//
//  Created by Shipu Wang on 2/18/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

class QuestionModel: BaseModel {

    var question : String?
    var answer : Int16?
    var myAnswer : Int16?
    var category : String?
    var option : Array<String>?
    
    
    enum QuestionKeys : Int {
        case KeyQuestion, KeyAnswer, KeyMyAnswer, KeyCategory, KeyOption1, KeyOption2, KeyOption3, KeyOption4, KeyOption5
        func toKey() -> String! {
            switch self {
            case .KeyQuestion:
                return "question"
            case .KeyAnswer:
                return "answer"
            case .KeyMyAnswer:
                return "myAnswer"
            case .KeyCategory:
                return "category"
            case .KeyOption1:
                return "option1"
            case .KeyOption2:
                return "option2"
            case .KeyOption3:
                return "option3"
            case .KeyOption4:
                return "option4"
            case .KeyOption5:
                return "option5"
            }
        }
    }
    
    
    required init(_ dictionary: Dictionary<String, AnyObject>) {
        
        super.init(dictionary)
        
        question    = dictionary[QuestionKeys.KeyQuestion.toKey()]  as? String
        answer      = Int16((dictionary[QuestionKeys.KeyAnswer.toKey()] as? String)!)
        myAnswer    = Int16((dictionary[QuestionKeys.KeyMyAnswer.toKey()] as? String) ?? "0")
        category    = dictionary[QuestionKeys.KeyCategory.toKey()]  as? String
        option      = [dictionary[QuestionKeys.KeyOption1.toKey()]  as? String,
                       dictionary[QuestionKeys.KeyOption2.toKey()]  as? String,
                       dictionary[QuestionKeys.KeyOption3.toKey()]  as? String,
                       dictionary[QuestionKeys.KeyOption4.toKey()]  as? String,
                       dictionary[QuestionKeys.KeyOption5.toKey()]  as? String] as? Array<String>
        
        
    }
}
