//
//  TableViewCell.swift
//  GameList
//
//  Created by John Wang on 8/4/21.
//

import UIKit
import EventKit

class GameTableViewCell: UITableViewCell {
    
    static let identifier = "GameCell"
    
    var formattedDate: String = ""
    
    var onCalendar: Bool = false
    var onNotify: Bool = false
    
    var eventId: String = ""
    var notificationId: String = ""
    
    var delegate: GameScheduleViewController!
    var index: Int!
    var uniqueIdentifer: Double!
    
    let eventStore = EKEventStore()
    
    let displayLabel = UILabel()
    
    var notifyButton: UIButton!
    var calanderButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var constraints: [NSLayoutConstraint] = []
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        constraints.append( displayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        constraints.append( displayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        
        self.calanderButton = UIButton(frame: .zero)
        
        self.calanderButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.calanderButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        self.calanderButton.tintColor = onCalendar ? UIColor.red : UIColor.gray
        self.calanderButton.addTarget(self, action: #selector(calanderButtonPressed), for: .touchUpInside)
        constraints.append(self.calanderButton.widthAnchor.constraint(equalToConstant: 20))
        constraints.append(self.calanderButton.heightAnchor.constraint(equalToConstant: 20))
        constraints.append(self.calanderButton.topAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -25))
        constraints.append(self.calanderButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20))
        
        self.contentView.addSubview(self.calanderButton)
        
        self.notifyButton = UIButton(frame: .zero)
        
        self.notifyButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.notifyButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        self.notifyButton.tintColor = onNotify ? UIColor.yellow : UIColor.gray
        self.notifyButton.addTarget(self, action: #selector(notifyButtonPressed), for: .touchUpInside)
        constraints.append(self.notifyButton.widthAnchor.constraint(equalToConstant: 20))
        constraints.append(self.notifyButton.heightAnchor.constraint(equalToConstant: 20))
        constraints.append(self.notifyButton.topAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -25))
        constraints.append(self.notifyButton.trailingAnchor.constraint(equalTo: self.calanderButton.leadingAnchor, constant: -20))
        
        self.contentView.addSubview(self.notifyButton)
  
       // toggle.addTarget(self, action: #selector(followedTeamsSwithch), for: .valueChanged)
        NSLayoutConstraint.activate(constraints)
        //displayLabel.frame = CGRect(x: 250, y:0, width: 150, height: contentView.frame.size.height)
        
    }
    
    @objc
    func notifyButtonPressed() {
        
        //TODO MAKE MULTIPLE one for one for an hour before?
        //TODO MAKE MULTIPLE one for one for an 30 min before?
        //TODO MAKE MULTIPLE one for one for an 5 min before?
        
        //TODO: Check if user has push notification on or off
        
        print("NOTIFICATION BUTTON PRESSED")
        let dateString = self.formattedDate // e.g. "2021-8-11T10:44:00+0000"
        let eventName = self.displayLabel.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: dateString)! as Date
        
        let fiveMinDate = date.addingTimeInterval(60 * -5)
        let hourDate = date.addingTimeInterval(60 * 60 * -1)
        let fiveHourDate = date.addingTimeInterval(60 * 60 * -5)
        
        //let nowDate = Date().addingTimeInterval(10)
    
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let dateComponents1 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fiveMinDate)
        let dateComponents2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: hourDate)
        let dateComponents3 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fiveHourDate)
        
        //let dateComponents4 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nowDate)
        
        if !(self.onNotify) {
            self.createNotifications(title: eventName!, subtitle: "", body: "Happening NOW!", date: dateComponents, identifier: notificationId)
            
            self.createNotifications(title: eventName!, subtitle: "", body: "Happening in FIVE minutes!", date: dateComponents1, identifier: "\(notificationId)1")
            self.createNotifications(title: eventName!, subtitle: "", body: "Happening in ONE hour!", date: dateComponents2, identifier: "\(notificationId)2")
            self.createNotifications(title: eventName!, subtitle: "", body: "Happening in FIVE hours", date: dateComponents3, identifier: "\(notificationId)3")
            
            //self.createNotifications(title: eventName!, subtitle: "", body: "TESTING", date: dateComponents4, identifier: "\(notificationId)4")
        }
        else {
            self.deleteNotifications(eventIdentifier: notificationId)
            
            self.deleteNotifications(eventIdentifier: "\(notificationId)1")
            self.deleteNotifications(eventIdentifier: "\(notificationId)2")
            self.deleteNotifications(eventIdentifier: "\(notificationId)3")
            
            //self.deleteNotifications(eventIdentifier: "\(notificationId)4")
        }
        self.onNotify.toggle()
    }
    
    func createNotifications (title: String, subtitle: String, body: String, date: DateComponents, identifier: String) {
        
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.subtitle = subtitle
        notification.body = body
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        
        // set up a request to tell iOS to submit the notification with that trigger
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notification,
                                            trigger: notificationTrigger)
        //notificationId = request.identifier
        
        // submit the request to iOS
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
            }
            print("success with notification")
        }
        self.delegate.updateNotification(index: self.index, remove: false)
        self.notifyButton.tintColor = UIColor.yellow
    }
    
    func deleteNotifications (eventIdentifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [eventIdentifier])
        self.notifyButton.tintColor = UIColor.gray
        self.delegate.updateNotification(index: self.index, remove: true)
        print("deleted notification")
    }
    
    @objc
    func calanderButtonPressed() {
        print("CALANDER BUTTON PRESSED")
        let dateString = self.formattedDate // e.g. "2021-8-11T10:44:00+0000"
        let eventName = self.displayLabel.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        print("\n\n\n dateString: \(dateString)")
        let startDate = dateFormatter.date(from: dateString)! as NSDate
        let endDate = startDate.addingTimeInterval(self.uniqueIdentifer).addingTimeInterval((60 * 60 * 3))
        
        print("\n\n\n startDate: \(startDate)")
        print("\n\n\n enddate: \(endDate)")
        
        if !(self.onCalendar) {
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                // request access
                eventStore.requestAccess(to: .event, completion: {
                    granted, error in self.createEvent(title: eventName!, startDate: startDate, endDate: endDate)
                })
            } else {
                // create the event
                createEvent(title: eventName!, startDate: startDate, endDate: endDate)
            }
        }
        else {
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                eventStore.requestAccess(to: .event, completion: {
                    granted, error in self.deleteEvent(startDate: startDate as Date, endDate: endDate as Date)
                })
            } else {
                deleteEvent(startDate: startDate as Date, endDate: endDate as Date)
            }
        }
        self.onCalendar.toggle()
    }
    
    func createEvent(title:String, startDate:NSDate, endDate:NSDate) {
        //let event = eventStore.event(withIdentifier: "3A758214-D33E-4C25-BA40-1C45CDCEAC56:53072782-5997-4797-9F0D-2E8E12A50EC3")
        DispatchQueue.main.async {
            self.calanderButton.tintColor = UIColor.red
        }
        let event = EKEvent(eventStore: eventStore)//EKEvent(eventStore: eventStore)
        event.title = title
        event.isAllDay = false
        event.startDate = startDate as Date?
        event.endDate = endDate as Date?
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            eventId = event.eventIdentifier
            print("IDENTIFER: \(event.eventIdentifier)")
        } catch {
            print("Error occurred during add")
        }
        self.delegate.updateCalendar(index: self.index, remove: false)
    }
    
    func deleteEvent(startDate: Date, endDate: Date) {
        let pred = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: pred)
        print ("about to delete")
        DispatchQueue.main.async {
            self.calanderButton.tintColor = UIColor.gray
        }
        //let eventToRemove = event//eventStore.event(withIdentifier: eventIdentifier)//"3A758214-D33E-4C25-BA40-1C45CDCEAC56:53072782-5997-4797-9F0D-2E8E12A50EC3")
        if (!(events.isEmpty)) {
            let eventToRemove = events[0]
            // event found in event store
            do {
                try eventStore.remove(eventToRemove, span: .thisEvent)
                print("deleted Event")
            } catch {
                print("Error occurred during delete")
            }
        }
        self.delegate.updateCalendar(index: self.index, remove: true)
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(displayLabel)
      
        displayLabel.textAlignment = .center
       // contentView.backgroundColor = UIColor(rgb: Constants.Colors.lightOrange)
      

        //userInformationLabel.text = " user Infor"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColor(color: UIColor) {
        contentView.backgroundColor = color
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
