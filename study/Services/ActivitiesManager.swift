//
//  ActivitiesManager.swift
//  study
//
//  Created by Shipu Wang on 2/17/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let ALL_CATEGORY = "All"

class ActivitiesManager:NSObject {
    
    private let QuestionModelName = "Question"
    private var context : NSManagedObjectContext? = nil
    private var delegate:AppDelegate? = nil
    
    
    static let shared: ActivitiesManager = {
        let instance = ActivitiesManager()
        instance.delegate = UIApplication.shared.delegate as? AppDelegate
        instance.context = instance.delegate?.persistentContainer.viewContext
        // setup code
        return instance
    }()
    
    func updateQuestions(array:Array<QuestionModel>) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: QuestionModelName)
        request.returnsObjectsAsFaults = false
        for model in array {
            request.predicate = NSPredicate(format: "id == %d", model.id)
            do {
                if let result = try context?.fetch(request) {
                    if result.count > 0 {
                        for oldQuestion in result as! [Question] {
                            self.updateOldQuestion(oldCDModel: oldQuestion, newModel: model)
                        }
                    } else {
                        let newQuestion = Question(context: context!)
                        self.setNewQuestion(newCDModel: newQuestion, newModel: model)
                    }
                }
            } catch {
                print("Failed in Core Data")
            }
        }
        self.delegate?.saveContext()
    }
    
    
    func updateOldQuestion(oldCDModel:Question, newModel:QuestionModel) {
        if oldCDModel.id != newModel.id {
            oldCDModel.id = newModel.id
        }
        if oldCDModel.question != newModel.question {
            oldCDModel.question = newModel.question
        }
        if oldCDModel.category != newModel.category {
            oldCDModel.category = newModel.category
        }
        if oldCDModel.option != newModel.option! {
            oldCDModel.option = newModel.option!
        }
        if oldCDModel.answer != newModel.answer {
            oldCDModel.answer = newModel.answer ?? 0
        }
        if oldCDModel.myAnswer != newModel.myAnswer {
            oldCDModel.myAnswer = newModel.myAnswer ?? 0
        }
    }
    
    func setNewQuestion(newCDModel:Question, newModel:QuestionModel) {
        newCDModel.id       = newModel.id
        newCDModel.question = newModel.question
        newCDModel.category = newModel.category
        newCDModel.option   = newModel.option!
        newCDModel.answer   = newModel.answer ?? 0
        newCDModel.myAnswer = newModel.myAnswer ?? 0
    }
    
    func fetchCategories() -> Set<String> {
        var set = Set<String>()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: QuestionModelName)
        request.returnsObjectsAsFaults = false
        do {
            if let result = try context?.fetch(request) {
                for row in result as! [Question] {
                    set.insert(row.category ?? "")
                }
            }
        } catch {
            print("Failed in Core Data")
        }
        return set
    }
    
    func updateMyAnswerForQuestion(id:Int16, myAnswer:Int16) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: QuestionModelName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            if let result = try context?.fetch(request) {
                if result.count > 0 {
                    for oldQuestion in result as! [Question] {
                        if oldQuestion.myAnswer != myAnswer {
                            oldQuestion.myAnswer = myAnswer
                        }
                    }
                }
            }
        } catch {
            print("Failed in Core Data")
        }
        self.delegate?.saveContext()
    }
    
    func fetchNumOfTakenQuestions(category:String?) -> Int{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: QuestionModelName)
        request.returnsObjectsAsFaults = false
        if category != ALL_CATEGORY {
            request.predicate = NSPredicate(format: "(category == %@) AND (myAnswer != 0)", category!)
        } else {
            request.predicate = NSPredicate(format: "myAnswer != 0")
        }
        
        do {
            if let result = try context?.fetch(request) {
                return result.count
            }
        } catch {
            print("Failed in Core Data")
        }
        
        return 0;
    }
    
    func fetchNumOfAvailableQuestions(category:String?) -> Int{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: QuestionModelName)
        request.returnsObjectsAsFaults = false
        if category != ALL_CATEGORY {
            request.predicate = NSPredicate(format: "category == %@", category!)
        }
        
        do {
            if let result = try context?.fetch(request) {
                return result.count
            }
        } catch {
            print("Failed in Core Data")
        }
        
        return 0;
    }
    
}
