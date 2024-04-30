//
//  CalendarViewController.swift
//  WasteNot
//
//  Created by David Allen on 4/13/24.
//

import UIKit

class CalendarViewController: UIViewController {

    var foods: [Food] = []

    private var expiringFoods: [Food] = []

    private var calendarView: UICalendarView!
    
    
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        setContentScrollView(tableView)
        
        self.calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarContainerView.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor),
            calendarView.topAnchor.constraint(equalTo: calendarContainerView.topAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendarContainerView.bottomAnchor)
        ])
        
        let calendarViewDateRange = DateInterval(start: Date.distantPast, end: Date.distantFuture)
        calendarView.availableDateRange = calendarViewDateRange

       
        calendarView.delegate = self
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection

        
        foods = Food.getFoods().filter({ (food:Food) -> Bool in
            return food.expirationDate != nil
        })
        
        let todayComponents = Calendar.current.dateComponents([.year, .month, .weekOfMonth, .day], from: Date())
        let expiringToday = filterFoods(for: todayComponents)
        if !expiringToday.isEmpty {
            let selection = calendarView.selectionBehavior as? UICalendarSelectionSingleDate
            selection?.setSelected(todayComponents, animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshFoods()
    }


    private func filterFoods(for dateComponents: DateComponents) -> [Food] {
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else {
            return []
        }
        let foodsMatchingDate = foods.filter { food in
            return calendar.isDate(food.expirationDate!, equalTo: date, toGranularity: .day)
        }
        return foodsMatchingDate
    }

    
    private func refreshFoods() {
        
        foods = Food.getFoods().filter({ (food:Food) -> Bool in
            return food.expirationDate != nil
        })
        
        foods.sort { lhs, rhs in
            return lhs.expirationDate! < rhs.expirationDate!
        }
        
        if let selection = calendarView.selectionBehavior as? UICalendarSelectionSingleDate,
            let selectedComponents = selection.selectedDate {

            expiringFoods = filterFoods(for: selectedComponents)
        }
        
        let calendar = calendarView.calendar
        var currentDay = DateComponents(
            year: calendarView.visibleDateComponents.year,
            month: calendarView.visibleDateComponents.month)
        currentDay.day = 1
        
        let currentMonth = calendar.date(from: currentDay)!
        
        let monthRange = calendar.range(of: .day, in: .month, for: currentMonth)!
        var dateComps: [DateComponents] = []
        for _ in monthRange {
            dateComps.append(currentDay)
            currentDay.day! += 1
        }
        
        calendarView.reloadDecorations(forDateComponents: dateComps, animated: false)
        tableView.reloadData()
    }
}

extension CalendarViewController: UICalendarViewDelegate {

    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        
        let foodsMatchingDate = filterFoods(for: dateComponents)
        
        if !foodsMatchingDate.isEmpty {
            let image = UIImage(systemName: "exclamationmark.triangle.fill")
            return .image(image, color: (dateComponents.date! < Date.now) ? .systemGray : .systemRed, size: .large)
        } else {
            return nil
        }
    }
    
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        let foodsMatchingDate = filterFoods(for: previousDateComponents)
        
        if !foodsMatchingDate.isEmpty {
            calendarView.reloadDecorations(forDateComponents: [previousDateComponents], animated: false)
        } else {
            return
        }
    }
}


extension CalendarViewController: UICalendarSelectionSingleDateDelegate {

    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let components = dateComponents else { return }
        
        expiringFoods = filterFoods(for: components)
        
        if expiringFoods.isEmpty {
            selection.setSelected(nil, animated: true)
        }

        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}


extension CalendarViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expiringFoods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        let food: Food = expiringFoods[indexPath.row]
        
        cell.configure(with: food)
        
        return cell
    }
}
