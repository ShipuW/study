//
//  QuestionCell.swift
//  study
//
//  Created by Shipu Wang on 2/18/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

@objc protocol QuestionCellDelegate: NSObjectProtocol{
    @objc optional func selectedAnswer(id:Int16, myAnswer:Int16)
}

class QuestionCell: UITableViewCell {

    weak var delegate: QuestionCellDelegate?
    
    var questionModel:Question?
    var myCurrentAnswer:Int16?
    
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet var collectionOfTextViews: Array<UITextView>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func configureForQuestionView(_ questionResult: Question){
        
        self.questionModel = questionResult
        self.cleanColor()
        self.showColor()
        questionTextView.attributedText = StringConverter.convertStringToHTMLAttributedString(string: (self.questionModel?.question)!)
        
        let optionCount = self.questionModel?.option.count
        for index in 0...optionCount! - 1 {
            collectionOfTextViews![index].attributedText = StringConverter.convertStringToHTMLAttributedString(string: (self.questionModel?.option[index])!)
            if (self.questionModel?.myAnswer)! - 1 == index {
                collectionOfTextViews![index].backgroundColor = UIColor.red
            }
            if (self.questionModel?.answer)! - 1 == index {
                collectionOfTextViews![index].backgroundColor = UIColor.green
            }
        }
    }
    
    func configureForQuestionStart(_ questionResult: Question, _ myAnswerDict:Dictionary<Int16, Int16>){
        
        self.questionModel = questionResult
        
        self.cleanColor()
        self.myCurrentAnswer = myAnswerDict[(questionModel?.id)!]
        self.showColor()

        
        questionTextView.attributedText = StringConverter.convertStringToHTMLAttributedString(string: (self.questionModel?.question)!)
        
        let optionCount = self.questionModel?.option.count
        
        for index in 0...optionCount! - 1 {
            collectionOfTextViews![index].attributedText = StringConverter.convertStringToHTMLAttributedString(string: (self.questionModel?.option[index])!)
            let tapTerm = UITapGestureRecognizer(target: self, action: #selector(tapOptionTextView(_:)))
            tapTerm.delegate = self
            collectionOfTextViews![index].addGestureRecognizer(tapTerm)
        }
    }
    
    @objc func tapOptionTextView(_ sender:UITapGestureRecognizer)
    {
        self.cleanColor()
        
        myCurrentAnswer = Int16(sender.view?.tag ?? 0)
        
        if let realDelegate = self.delegate{
            realDelegate.selectedAnswer!(id: (self.questionModel?.id)!, myAnswer: Int16(sender.view?.tag ?? 0))
        }
        
        self.showColor()

    }
    
    func showColor() {
        if let showingAnswer = myCurrentAnswer {
            if showingAnswer > 0 {
                collectionOfTextViews![Int(showingAnswer - 1)].backgroundColor = UIColor.red
            }
            
            let ansIndex = Int((self.questionModel?.answer)! - 1)
            collectionOfTextViews![ansIndex].backgroundColor = UIColor.green
        }

        
    }
    
    func cleanColor() {
        let optionCount = self.questionModel?.option.count
        for index in 0...optionCount! - 1 {
            collectionOfTextViews![index].backgroundColor = UIColor.white
        }
    }
    
    
    // MARK - UIGestureRecognizerDelegate - reponse textview and tap at the same time
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
