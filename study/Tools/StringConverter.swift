//
//  StringConverter.swift
//  study
//
//  Created by Shipu Wang on 2/18/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//

import Foundation

class StringConverter {
    class func convertStringToHTMLAttributedString (string:String) -> NSAttributedString {
        let htmlData = NSString(string: string).data(using: String.Encoding.unicode.rawValue)
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        
        return  attributedString
    }
}
