//
//  String+Ext.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 30/05/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

extension String {

    func convertStringDateToString(
                        inputFormat: String,
                        outputFormat: String,
                        identifierLocale locale: String,
                        secondsFromGMT seconds: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: seconds)
        dateFormatter.dateFormat = inputFormat

        guard let date = dateFormatter.date(from: self) else { return nil }

        dateFormatter.dateFormat = outputFormat
        let outputStringDate = dateFormatter.string(from: date)

        return outputStringDate.capitalized
    }

}

