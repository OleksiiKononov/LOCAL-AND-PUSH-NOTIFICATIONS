//
//  UserNotification.swift
//  Swift Essential
//
//  Created by SASMobile on 25.03.2021.
//  Copyright © 2021 Oleksii Kononov. All rights reserved.
//
import UIKit
import UserNotifications

class  UserNotifications: NSObject {
    
    struct Identifier {
          static let happyAction = "Happy"
          static let customCategory = "Essential"
          static let viewAction = "View app"
      }
    
    static let shared = UserNotifications()
    
    override init() {
        super.init()
        initCategories()
    }

    func initCategories() {
        let action1 = UNNotificationAction(identifier: Identifier.happyAction,
                                           title: "I'm happy",
                                           options: .destructive)
        
        let action2 = UNNotificationAction(identifier: Identifier.viewAction,
                                                 title: "Open app",
                                                 options: .foreground)
        
        let category = UNNotificationCategory(identifier: Identifier.customCategory,
                                              actions: [action1, action2],
                                              intentIdentifiers: [],
                                              options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if success {
                self.createNotification()
                DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print(error?.localizedDescription ?? "No error")
            }
        }
    }
    
    func createNotification () {
    
        let content = UNMutableNotificationContent()
        
        content.title = "Hello my friend"
        content.subtitle = "It's your best day"
        content.body = "You neet to go work"
        content.sound = UNNotificationSound.default
        
        if let path = Bundle.main.path(forResource: "yahoo", ofType: "png"){
            let url = URL.init(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "happy",
                                                              url: url,
                                                              options: nil)
                content.attachments = [attachment]
            } catch {
                print(error.localizedDescription)
            }
        }
        
        content.categoryIdentifier = Identifier.customCategory
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Notification",
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension UserNotifications: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case Identifier.happyAction:
            print("I'm happy!")
        case Identifier.viewAction:
            print("You are opened app")
        case UNNotificationDefaultActionIdentifier:
            print("Opened without notification")
        case UNNotificationDismissActionIdentifier:
            print("Dismissed notification")
        default:
            print("Undefined")
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}


