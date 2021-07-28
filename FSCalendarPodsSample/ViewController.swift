//
//  ViewController.swift
//  FSCalendarPodsSample
//
//  Created by 小川卓馬 on 2021/07/25.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class ViewController: UIViewController {

    @IBOutlet weak private var calendar: FSCalendar!
    @IBOutlet weak private var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak private var selectDateLabel: UILabel!
    private var isDisplayMonth = true

    let gredorian: Calendar = Calendar(identifier: .gregorian)
    // lazyの使い方は後で調べる。なんで必要なのか
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.dataSource = self
        calendar.delegate = self

        calendar.appearance.headerDateFormat = "yyyy年MM月"

        calendar.appearance.todayColor = .red
        calendar.appearance.headerTitleColor = .blue
        calendar.appearance.weekdayTextColor = .green
    }

    @IBAction func tapToggleWeekOrMonthButton(_ sender: UIButton) {
        isDisplayMonth.toggle()
        isDisplayMonth
            ? calendar.setScope(.month, animated: true)
            : calendar.setScope(.week, animated: true)
    }

}

extension ViewController {
    func judgeHoliday(_ date: Date) -> Bool {
        let tmpCalendar = Calendar(identifier: .gregorian)

        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }

    func getDate(_ date: Date) -> (year: Int, month: Int, day: Int) {
        let tmpCalendar = Calendar(identifier: .gregorian)

        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        return (year, month, day)
    }

    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIndex(_ date: Date) -> Int {
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
}

extension ViewController: FSCalendarDataSource {

}

extension ViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectDay = getDate(date)
        let labelText = "\(selectDay.month)月\(selectDay.day)日を選択"
        selectDateLabel.text = labelText
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        view.layoutIfNeeded()
    }
}

extension ViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {

        if judgeHoliday(date) {
            return .red
        }

        let weekday = getWeekIndex(date)
        if weekday == 1 {
            return .red
        } else if weekday == 7 {
            return .blue
        }

        return nil
    }
}

