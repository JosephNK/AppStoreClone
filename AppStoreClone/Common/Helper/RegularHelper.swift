//
//  RegularHelper.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

extension String {
    
    static func checkRegularOnlyKorean(_ text: String) -> Bool {
        // Check Only Korean Regular
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣]"
        let regex = try! NSRegularExpression(pattern:pattern, options:[])
        let list = regex.matches(in: text, options: [], range: NSRange.init(location: 0, length:text.count))
        if list.count <= 0 {
            return false
        }
        
        return true
    }
    
}
