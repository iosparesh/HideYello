//
//  LocalNotificationManager.swift
//  RXVVM
//
//  Created by Paresh Prajapati on 08/09/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import UserNotifications

class LocalNotificationManager: NSObject {
    var notifications = [UserNotification]()
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    // We have permission!
                }
        }
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }
    
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    
    func addNotification(notification: UserNotification) -> Void {
        notifications.append(notification)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }
}
extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    
}

struct UserNotification {
    var id: String
    var title: String
    var body: String = ""
    var categoryIdentifier: String = ""
    var userInfo: [String: Any] = [:]
    var sound = UNNotificationSound.default
}
struct UTCTime: Codable {
    let response_status: String?
    let message: String?
    let server_utc_time: String
}
