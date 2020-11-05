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
                        let activityTypes = ["fitness", "learning", "chores", "work"]
                        //Cycle through categories
                        for (index, category) in arrayContents.enumerated() {

                            //Create Category and assign name
                            let categoryObject = ActivityCategory(context: backgroundContext)
                            categoryObject.categoryName = activityTypes[index]

                            //Cycle through activities in each Category
                            for activity in category {
                                let activityObject = Activity(context: backgroundContext)
                                activityObject.name = activity ?? "Unknown Activity"
                                activityObject.itemInCategory = categoryObject
//                                print(activity)
                            }
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


