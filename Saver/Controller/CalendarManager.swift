//
//  CalendarManager.swift
//  Saver
//
//  Created by 조성빈 on 6/4/24.
//

import UIKit

class CalendarManager {
    static let manager = CalendarManager()
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    var calendarDate = Date()
    private var days: [String]
    
    private init() {
        days = []
        self.dateFormatter.dateFormat = "yyyy년 M월"
    }
    
    // 달력 초기화
    func configureCalendar(date: Date) {
        let components = self.calendar.dateComponents([.year, .month], from: date)
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        print("configureCalendar() 실행, \(self.calendarDate).")
    }
    
    // 1일이 무슨 요일인지?
    func weekOfFirstDay() -> Int {
        let numberOfWeekDay = self.calendar.component(.weekday, from: self.calendarDate) - 1
        return numberOfWeekDay
    }
    
    // 특정 날짜의 요일
    func weekOfDay(date: Date) -> Int {
        let numberOfWeekDay = self.calendar.component(.weekday, from: date) - 1
        return numberOfWeekDay
    }
    
    // 해당 달의 날짜 개수(28~31)
    func countDayInMonth() -> Int {
        let countOfDay = self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? 0
        return countOfDay
    }
    
    // 달의 1일이 무슨 요일인지 파악 후, 달력의 날짜 요소들을 days에 업데이트
    func updateDays() {
        self.days.removeAll()
        let weekOfFirstDay = self.weekOfFirstDay() // 1일이 무슨 요일인지?
        let countOfDay = self.countDayInMonth() // 이 달은 며칠인지?
        let countOfDayInMonth = weekOfFirstDay + countOfDay // 두 값을 더해 1일 이전의 요일들을 빈값으로 구성
        
        for day in 0..<countOfDayInMonth {
            switch day {
            case ..<weekOfFirstDay:
                self.days.append("")
            default:
                self.days.append(String(day - weekOfFirstDay + 1))
            }
        }
        
        print("updateDays() 실행, \(self.days)")
    }
    
    // days.count
    func countOfDays() -> Int {
        let count = self.days.count
        return count
    }
    
    // days 전체를 반환
    func getDays() -> [String] {
        return self.days
    }
    
    // HomeView의 changeMonthButton의 text를 업데이트
    func updateYearMonthLabel(label: UILabel) {
        let currentYearMonthString = self.dateFormatter.string(from: self.calendarDate)
        label.text = currentYearMonthString
        print("updateYearMonthLabel() 실행")
    }
    
    // 이전 달
    func prevMonth() {
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate) ?? Date()
    }
    
    // 다음 달
    func nextMonth() {
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: 1), to: self.calendarDate) ?? Date()
    }
}
