//
//  QuestionCell.swift
//  study
//
//  Created by Shipu Wang on 2/18/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    var questionModel:Question?
    
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet var collectionOfTextViews: Array<UITextView>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    func configureForQuestion(_ questionResult: Question){
        
        self.questionModel = questionResult
        
        questionTextView.attributedText = StringConverter.convertStringToHTMLAttributedString(string: (self.questionModel?.question)!)

        let optionCount = self.questionModel?.option.count
        for index in 0...optionCount! - 1 {
            collectionOfTextViews![index].attributedText = StringConverter.convertStringToHTMLAttributedString(string: (self.questionModel?.option[index])!)
        }
        
        
    }
    
    
    
    
    
}
