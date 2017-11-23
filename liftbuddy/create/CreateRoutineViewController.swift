import Foundation
import UIKit
import RealmSwift

class CreateRoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var routine: Routine?
    var routineId: Int?
    let realm = try! Realm()
    @IBOutlet weak var routineTableView: UITableView!
    @IBOutlet weak var routineNameLabel: UILabel!
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        RealmManager.shared.saveChanges()
        navigateRoutineList()
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        RealmManager.shared.discardChanges()
        navigateRoutineList()
    }
    
    private func navigateRoutineList(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newRoot = storyBoard.instantiateViewController(withIdentifier: "RoutineListTableViewController")
        self.navigationController?.setViewControllers([newRoot], animated: true)
    }
    
    @IBAction func addWorkoutButtonWasPressed(_ sender: Any) {
        guard let routineId = routineId else { return }
        
        routine?.addWorkout(id: routineId)
        
        self.routineTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            guard let routineToDeleteFrom = routine else { return }
            
            if routineToDeleteFrom.workout.count >= indexPath.row  {
                routineToDeleteFrom.workout.remove(at: indexPath.row)
                self.routineTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            self.routineTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfWorkouts = routine?.workout.count else { return 0 }
        
        return numberOfWorkouts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutCell,
            let workout = routine?.workout[indexPath.row]
        else { return UITableViewCell() }

        cell.workout = workout
        cell.numberOfSetsLabel.text = "Sets: \(String(describing: workout.lifts.count))"
        cell.workoutNameTextField.text = workout.name
        
        guard let rest = workout.rest.value else { return cell }
        
        cell.restPicker.selectRow(rest / 5 , inComponent: 0, animated: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destination = storyboard.instantiateViewController(withIdentifier: "EditWorkoutViewController") as? EditWorkoutViewController, let workout = routine?.workout[indexPath.row] {
            
            destination.workout = workout
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        routineTableView.delegate = self
        routineTableView.dataSource = self
        
        RealmManager.shared.beginWrite()
        
        setRoutine()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController && RealmManager.shared.realm.isInWriteTransaction {
            RealmManager.shared.discardChanges()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.routineTableView.reloadData()
    }

    private func setRoutine(){
        guard let id = routineId,
            let existingRoutine = RoutineManager.getRoutineBy(id: id)
        else {
            routineId = routine?.id
            RoutineManager.create(routine: routine!) // refactor out force unwrap
            setLabels()
            return
        }
        
        self.routine = existingRoutine
        setLabels()
    }
    
    private func setLabels(){
        guard let routineName = routine?.name else { return }
        routineNameLabel.text = routineName
    }
}
