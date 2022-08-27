//
//  ContentView.swift
//  Gaiwa
//
//  Created by duanwenpu on 2022/2/24.
//

import SwiftUI
    

struct ContentView: View {
    var body: some View {
        return GWHomeTabView()
//        Button.init {
//            var dayDate = Ref<GWDateDay>.init()
//            dayDate.day = 10
//            dayDate.day = 10
//            var box = Box<GWDateDay>.init(Ref<GWDateDay>.init(dayDate as! GWDateDay) as! GWDateDay)
//            let dateDay = testDateDay()

//            var calendar = Calendar.current
//            calendar.locale = Locale.init(identifier: "zh_CN")
//            calendar.firstWeekday = 3
//            let monthDateComponents = calendar.dateComponents([ Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfMonth, Calendar.Component.weekday, Calendar.Component.weekOfYear], from: Date())
//            var d = Date()
//            d+=(24*60*60)
//            let next = calendar.dateComponents([.year, .month, .day,], from: d)
//
//            let updateCalendar = Calendar.autoupdatingCurrent
//            let firstWeekDay = calendar.firstWeekday
//            let updateFirstWeekDay = updateCalendar.firstWeekday
//            print("calendar:\(calendar.debugDescription)+updateCalendar:\(updateCalendar)")
//        } label: {
//            Text("click");
//        }
//
//        Text("Hello, world!")
//            .padding()
            
    }
}

func address(object: UnsafeRawPointer) -> String {
    let address = Int(bitPattern: object)
    return String(format: "%p", address)
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        GWHomeTabView()
//    }
//}
