//
//  DateFormatter.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import Foundation

class MyDateFormatter {
    static func getNormalDateFormat(from date: String) -> Date?{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            return dateFormatter.date(from: date)
    }
}
