//
//  oneMinuteApp.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-04.
//

import SwiftUI

@main
struct oneMinuteApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        preloadData()

        return true
    }
    
    private func preloadData() {

        let preloadedDataKey = "didPreloadData"
        let userDefaults = UserDefaults.standard

        //Check to see if preload has been run before
        if userDefaults.bool(forKey: preloadedDataKey) == false {
            //preload
            guard let urlPath = Bundle.main.url(forResource: "PreloadedData", withExtension: "plist") else {
                return
            }

            let backgroundContext = PersistenceController.shared.container.newBackgroundContext()

            backgroundContext.perform {
                if let arrayContents = NSArray(contentsOf: urlPath) as? [[String?]] {

                    do {
                        //Cycle through activities and create them and assign name/category
                        for activity in arrayContents {

                            let activityObject = Activity(context: backgroundContext)
                            activityObject.name = activity[1] ?? "Unknown Activity"
                            activityObject.category = activity[0] ?? "Unknown Category"
//                                print(activity)
                            
                        }

                        //Save categories and Items and change key so preloaded data won't be loaded again
                        try backgroundContext.save()
                        userDefaults.setValue(true, forKey: preloadedDataKey)

                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}


