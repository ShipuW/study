//
//  WelcomeViewController.swift
//  study
//
//  Created by Shipu Wang on 2/17/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var categories = Set<String>()
    var pickerData: [String] = [String]()
    private var currentCategory = ALL_CATEGORY
    private var numOfTakenQuestions = 0;
    private var numOfAvailableQuestions = 0;
    
    
    
    @IBOutlet weak var CategoryTextField: UITextField!
    @IBOutlet weak var QuestionNumberLabel: UILabel!
    @IBOutlet weak var CategoryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LoadUI()
//        self.UpdateQuestions()
        self.ReloadCategory()
        self.ReloadNumber()
        
    }

    func LoadUI () {
        self.title = "Welcome"
        self.CategoryPicker.delegate = self
        self.CategoryPicker.dataSource = self
    }
    
    func UpdateQuestions () {
        if let path = Bundle.main.path(forResource: "questions", ofType: "plist") {
            let arrayRoot = NSArray(contentsOfFile: path)
            if let array = arrayRoot {
                let questions:[QuestionModel] = QuestionModel.ArrayFromArray(array: array as! Array<Any>) as! [QuestionModel]
                ActivitiesManager.shared.updateQuestions(array: questions)
            }
        }
    }
    
    func ReloadCategory () {
        categories = ActivitiesManager.shared.fetchCategories()
        self.ResetPickerData()
    }
    
    func ReloadNumber() {
        CategoryTextField.text = currentCategory
        numOfTakenQuestions = ActivitiesManager.shared.fetchNumOfTakenQuestions(category: currentCategory)
        numOfAvailableQuestions = ActivitiesManager.shared.fetchNumOfAvailableQuestions(category: currentCategory)
        QuestionNumberLabel.text = String(format:"%d/%d",numOfTakenQuestions,numOfAvailableQuestions)
    }
    
    func ResetPickerData () {
        pickerData.removeAll()
        pickerData.append(ALL_CATEGORY)
        for category in categories {
            pickerData.append(category)
        }
    }
    
    // MARK - UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCategory = pickerData[row]
        self.ReloadNumber()
    }
    
    @IBAction func ReviewButtonTapped(_ sender: UIButton) {
        let questionsVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionsViewController") as! QuestionsViewController
        questionsVC.isReviewMode = true
        questionsVC.currentCategory = currentCategory
        self.navigationController?.pushViewController(questionsVC, animated: true)
    }
    @IBAction func StartButtonTapped(_ sender: UIButton) {
        let questionsVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionsViewController") as! QuestionsViewController
        questionsVC.isReviewMode = false
        questionsVC.currentCategory = currentCategory
        self.navigationController?.pushViewController(questionsVC, animated: true)
    }
}
