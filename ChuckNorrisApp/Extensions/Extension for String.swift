//
//  Extension for String.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 17.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import Foundation

extension String {
    
    // Special characters converter for &quot cases from icndb.com
    func convertSpecialCharacters() -> String {
        var newString = self
        let charactersDictionary = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'"
        ]
        for (escapedChar, unescapedChar) in charactersDictionary {
            newString = newString.replacingOccurrences(of: escapedChar, with: unescapedChar, options: .regularExpression, range: nil)
        }
        return newString
    }
    
}
