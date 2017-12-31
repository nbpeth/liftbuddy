
import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = Theme.violet
        navigationBarAppearace.barTintColor = Theme.tabBarColor
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("!!! \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true

        if(RealmManager().realm.objects(ExerciseDefinition.self).count < 1){
            RealmManager().beginWrite()
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Quads/Glutes", name:"Barbell Squat"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Quads/Glutes", name:"Barbell Hack Squat"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Quads/Glutes", name:"Front Squat"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Quads/Glutes", name:"Dumbbell Lunge"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Quads/Glutes", name:"Dumbbell Lunge"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Quads/Glutes", name:"Leg Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Quads/Glutes", name:"Leg Extension"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Quads/Glutes", name:"Wall Sit"))

            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Barbell Bench Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Pushup"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Incline Pushup"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Narrow Grip Pushup"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Dumbbell Bench Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Incline Barbell Bench Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Decline Barbell Bench Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Chest Fly"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Lying Chest Fly"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Chest", name:"Incline Chest Fly"))


            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Calves", name:"Calf Raise"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Calves", name:"Dumbbell Calf Raise"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Calves", name:"Single-leg Calf Raise"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Calves", name:"Donkey Calf Raise"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Calves", name:"Standing Calf Raise"))
            
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Hamstrings", name:"Leg Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Hamstrings", name:"Lying Leg Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Hamstrings", name:"Snatch"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Hamstrings", name:"Romanian Deadlift"))

            
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Triceps", name:"Pushdown"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Triceps", name:"Tricep Extension"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Triceps", name:"Lying Tricep Extension"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Triceps", name:"Dumbbell Kickback"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Triceps", name:"Narrow Grip Barbell Bench Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Triceps", name:"Dumbbell Skullcrusher"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Triceps", name:"EZ Bar Skullcrusher"))



            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Barbell Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Cable Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Overhead Cable Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Overhead Barbell Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Incline Dumbbell Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Standing Barbell Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Dumbbell Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Standing Dumbbell Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Hammer Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Standing Hammer Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Barbell Preacher Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Dumbbell Preacher Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Preacher Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Zottmann Curl"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Biceps", name:"Alternating Rotating Curl"))
            
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Shoulder Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Arnold Dumbbell Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Band Back Flyes"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Arm Circles"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Standing Shoulder Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Dumbbell Shoulder Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Standing Dumbbell Shoulder Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Upright Row"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Upright Cable Row"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Barbell Upright Row"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Military Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Barbell Shrug"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Dumbbell Shrug"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Machine Shrug"))

            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Forearms", name:"Barbell Wrist Curls"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Forearms", name:"Dumbbell Wrist Curls"))


            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Seated Shoulder Press"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Front Dumbbell Raise"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Lateral Dumbbell Raise"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Shoulders", name:"Shoulder Fly"))
            
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Abdominals", name:"Situps"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Abdominals", name:"Crunches"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Abdominals", name:"Leg Pull-in"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Abdominals", name:"Gorilla Chin"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Abdominals", name:"Incline Crunches"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Abdominals", name:"Leg Raise"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Abdominals", name:"Hanging Leg Raise"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Abdominals", name:"Ab Wheel"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Abdominals", name:"Russian Twist"))

            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Lower Back", name:"Back Extension"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Lower Back", name:"Good-Morning"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Lower Back", name:"Stiff-legged Deadlift"))

            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Lats", name:"Wide Grip Pulldown"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Lats", name:"Narrow Grip Pulldown"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Lats", name:"Chin-up"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Lats", name:"Pull-Up"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Lats", name:"Bent over row"))

            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Middle Back", name:"Seated Row"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Middle Back", name:"Seated Cable Row"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Middle Back", name:"T-Bar Row"))
            RealmManager().realm.add(ExerciseDefinition(muscleGroup:"Middle Back", name:"Bent-over Barbell Row"))




            
            
            




            RealmManager().saveChanges()
        }

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

