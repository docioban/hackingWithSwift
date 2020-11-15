//
//  ViewController.swift
//  Project21
//
//  Created by Macbook Pro on 11/14/20.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                print("Hey")
            } else {
                print("No")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 12
//        dateComponents.minute = 12
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 8, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Some title"
        content.body = "Main text of notification"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "Hello world!"]
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let ok = UNNotificationAction(identifier: "ok", title: "OK", options: [])
        let remaindLater = UNNotificationAction(identifier: "remind", title: "Remaind me later", options: [])
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, ok, remaindLater], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data resever is: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default action")
            case "show":
                print("Button show")
            case "ok":
                print("OK")
            case "remind":
                remindDay()
                print("remind")
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func remindDay() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Remind notification"
        content.body = "24 hour notification"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "Remind notification"]
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}

