//
//  ViewController.swift
//  FSCalendarPodsSample
//
//  Created by 小川卓馬 on 2021/07/25.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.appearance.todayColor = .red
        calendar.appearance.headerTitleColor = .blue
        calendar.appearance.weekdayTextColor = .green
    }


}

