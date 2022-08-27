//
//  GWDayModel.swift
//  Gaiwa
//
//  Created by duanwenpu on 2022/2/24.
//

import Foundation

protocol GWDayRecordList: NSObject {
    
}

protocol GWDateDay {
    static var day: Int {get set}

}

final class GWDayRecordModel:Identifiable {

}

final class GWDateDayModel:Identifiable {
    var dateDay: Int = 0
    var dateYear: Int = 0
    var dateMonth: Int = 0
    var dateWeekDay: Int = 0
    var isToday: Bool = false
}

final class GWDayModel:Identifiable {
    var dateDay: GWDateDayModel?
    var dayRecordList: [GWDayRecordModel]?
}

final class GWMonthModel:Identifiable {
    var daysInMonth: [GWDayModel]?
    var dateMonth: Int = 0
    var dateYear: Int = 0
    var id = UUID()
}
