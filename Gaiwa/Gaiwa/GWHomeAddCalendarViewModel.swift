//
//  GWHomeAddCalendarViewModel.swift
//  Gaiwa
//
//  Created by duanwenpu on 2022/3/3.
//

import Foundation

extension Date {
    // 转成当前时区的日期
    func dateFromGMT() -> Date {
        let secondFromGMT: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return self.addingTimeInterval(secondFromGMT)
    }
    func currentDayzeroOfDate() -> Date {
        let calendar = Calendar.current
        var todayDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone], from: self)
        todayDateComponents.hour = 0
        todayDateComponents.minute = 0
        todayDateComponents.second = 0
        return calendar.date(from: todayDateComponents)?.dateFromGMT() ?? Date().dateFromGMT()
    }
}

class GWHomeAddCalendarViewModel {
    func loadRecentSevenMonthOfCurrentDay(currentDay: Date) -> [GWMonthModel] {
        let calendar = Calendar.current
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDay)
        let todayIndex = todayDateComponents.month ?? 0
        let recentRange = (todayIndex - 2)...(todayIndex + 2)
        var resultArray: [GWMonthModel] = []
        for monthIndex in recentRange {
            let monthModel = GWMonthModel.init()
            var year: Int
            var month: Int
            if monthIndex < 0 {
                year = todayDateComponents.year ?? 0 - 1
                month = 11 + monthIndex
            } else if monthIndex == 0 {
                year = todayDateComponents.year ?? 0 - 1
                month = 12
            } else {
                year = todayDateComponents.year ?? 0
                month = monthIndex
            }
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDay)
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = 1;
            monthModel.dateMonth = month
            monthModel.dateYear = year
            monthModel.daysInMonth = self.loadCurrentDayOfMonth(currentDay: calendar.date(from: dateComponents)?.dateFromGMT() ?? Date().dateFromGMT())
            resultArray.append(monthModel)
        }
        return resultArray
    }
    func loadCurrentDayOfMonth(currentDay: Date) -> [GWDayModel] {
        let calendar = Calendar.current
        let monthRange: Range = calendar.range(of: .day, in: .month, for: currentDay) ?? 0..<0
        var resultArray: [GWDayModel] = []
        let todayDateComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: currentDay)
        var trailDayOfUpMonth: Date = currentDay.currentDayzeroOfDate();
        let interval = -(TimeInterval((todayDateComponents.day ?? 0) * 24 * 60 * 60))
        trailDayOfUpMonth.addTimeInterval(interval)

        for dayIndex in monthRange {
            let dayModel = GWDayModel.init()
            let dateDayModel = GWDateDayModel.init()
            trailDayOfUpMonth.addTimeInterval(24 * 60 * 60)
            let dateComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: trailDayOfUpMonth)
            dateDayModel.dateDay = dateComponents.day ?? 0
            dateDayModel.dateYear = dateComponents.year ?? 0
            dateDayModel.dateMonth = dateComponents.month ?? 0
            dateDayModel.dateWeekDay = dateComponents.weekday ?? 0
            dateDayModel.isToday = dayIndex == todayDateComponents.day
            dayModel.dateDay = dateDayModel
            resultArray.append(dayModel)
        }
        
        return resultArray
    }
}

