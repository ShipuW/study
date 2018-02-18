//
//  WelcomeViewController.swift
//  study
//
//  Created by Shipu Wang on 2/17/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LoadUI()
        self.LoadQuestions()
        
    }

    func LoadUI () {
        self.title = "Welcome"
    }
    
    func LoadQuestions () {
        if let path = Bundle.main.path(forResource: "questions", ofType: "plist") {
            let arrayRoot = NSArray(contentsOfFile: path)
            if let array = arrayRoot {
                let questions:[QuestionModel] = QuestionModel.ArrayFromArray(array: array as! Array<Any>) as! [QuestionModel]
                ActivitiesManager.shared.updateQuestions(array: questions)
            }
        }
    }
}
