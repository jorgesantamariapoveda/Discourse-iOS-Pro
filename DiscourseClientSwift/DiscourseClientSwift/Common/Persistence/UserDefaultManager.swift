//
//  UserDefaultManager.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 31/05/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import Foundation

struct UserDefaultManager {

    static private let userDefault = UserDefaults.standard

    static func isLeftHand() -> Bool {
        return userDefault.bool(forKey: keyLeftHand)
    }

    static func setHandType(type: HandType) {
        switch type {
            case .letfHand:
                userDefault.set(true, forKey: keyLeftHand)
            case .rightHand:
                userDefault.set(false, forKey: keyLeftHand)
        }
    }
}
