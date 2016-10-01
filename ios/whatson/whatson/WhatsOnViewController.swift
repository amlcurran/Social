//
//  WhatsOnViewController.swift
//  whatson
//
//  Created by Alex on 02/10/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class WhatsOnViewController: UIViewController, EKEventEditViewDelegate, UIViewControllerPreviewingDelegate, WhatsOnPresenterDelegate,
    UITableViewDelegate, UITableViewDataSource {
    
    var dateFormatter : DateFormatter!;
    var eventStore : EKEventStore!;
    var dayColor : UIColor!;
    var presenter : WhatsOnPresenter!
    var calendarSource : SCCalendarSource?;
    var eventService : SCEventsService!;
    let timeCalculator = NSDateCalculator();
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        eventStore = EKEventStore()
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView);
        }
        dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "EEE";
        dayColor = UIColor.black.withAlphaComponent(0.54);
        let timeRepo = TimeRepository()
        let eventRepo = EventStoreRepository(timeRepository: timeRepo)
        eventService = SCEventsService(scTimeRepository: timeRepo, with: eventRepo, with: NSDateCalculator())
        presenter = WhatsOnPresenter(eventStore: eventStore, eventService: eventService)
        
        navigationController?.navigationBar.barTintColor = UIColor.appColor().withAlphaComponent(0.4)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.eightyWhite()
        #if DEBUG
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        #endif
        
        view.addSubview(tableView)
        tableView.constrainToSuperview(edges: [.top, .bottom, .leading, .trailing])
        
        title = "What's On";
        
        let newCellNib = UINib(nibName: "CalendarCell", bundle: Bundle.main)
        tableView.register(newCellNib, forCellReuseIdentifier: "day");
        tableView.rowHeight = 60;
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func eventsChanged() {
        presenter.refreshEvents()
    }
    
    func editTapped() {
        let options = OptionsViewController.create()
        let navigationController = UINavigationController(rootViewController: options)
        present(navigationController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        NotificationCenter.default.addObserver(self, selector:#selector(eventsChanged), name: NSNotification.Name.EKEventStoreChanged, object: eventStore)
        presenter.beginPresenting(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        NotificationCenter.default.removeObserver(self);
        presenter.stopPresenting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let slot = self.calendarSource?.slotAt(with: jint((indexPath as NSIndexPath).row)),
            let item = self.calendarSource?.itemAt(with: jint((indexPath as NSIndexPath).row)) else {
            preconditionFailure("Accessing a slot which doesn't exist")
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath) as! CalendarSourceViewCell;
        cell.bind(item, slot: slot);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = calendarSource?.count() {
            return Int(count);
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.calendarSource?.itemAt(with: jint((indexPath as NSIndexPath).row)) else {
            preconditionFailure("Calendar didn't have item at expected index \((indexPath as NSIndexPath).row)")
        }
        if item.isEmpty() {
            let addController = addEventController(item);
            self.navigationController?.present(addController, animated: true, completion: nil);
        } else {
            if let editController = editEventController(item as! SCEventCalendarItem) {
                self.navigationController?.pushViewController(editController, animated: true)
            }
        }
    }
    
    func addEventController(_ calendarItem: SCCalendarItem) -> UIViewController {
        let newEvent = EKEvent(eventStore: eventStore);
        let startDate = timeCalculator.date(calendarItem.startTime());
        let endDate = timeCalculator.date(calendarItem.endTime());
        let editController = EKEventEditViewController();
        newEvent.startDate = startDate;
        newEvent.endDate = endDate;
        editController.eventStore = eventStore;
        editController.event = newEvent;
        editController.editViewDelegate = self;
        return editController;
    }
    
    func editEventController(_ calendarItem: SCEventCalendarItem) -> UIViewController? {
        let itemId = calendarItem.id__();
        guard let event = eventStore.event(withIdentifier: itemId!) else {
            return nil
        }
//        let showController = EKEventViewController();
//        showController.event = event;
        let showController = EventDetailsViewController(event: event)
        return showController;
    }
    
    // MARK: - edit view delegate
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.navigationController?.dismiss(animated: true, completion: nil);
    }
    
    // MARK: - peek and pop
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath),
            let item = self.calendarSource?.itemAt(with: jint((indexPath as NSIndexPath).row)) else {
                return nil
        }
    
        previewingContext.sourceRect = cell.frame
        
        if item.isEmpty() {
            return nil;
        } else {
            let vc = editEventController(item as! SCEventCalendarItem)
            vc?.preferredContentSize = self.view.frame.size
            return vc
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true);
    }
    
    func didUpdateSource(_ source: SCCalendarSource) {
        self.calendarSource = source;
        self.tableView.reloadData();
    }
    
    func failedToAccessCalendar(_ error: NSError?) {
        print(error)
    }

}
