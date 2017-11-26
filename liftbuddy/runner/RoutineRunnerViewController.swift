import UIKit
import Foundation

class RoutineRunnerViewController:UIViewController {
    @IBOutlet weak var nameLabel: UILabel!

    var routineInProgress:RoutineInProgress?
    var runner: RoutineRunner?
    
    @IBAction func nextLiftButton(_ sender: Any) {
        print(runner?.nextLiftSet())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let routine = routineInProgress?.routine else { return }
        runner = RoutineRunner(routine: routine)

        nameLabel.text = runner?.currentWorkout?.name ?? "nothing here"
        
//        print(runner?.currentWorkout)
        
        
    }
    
}
