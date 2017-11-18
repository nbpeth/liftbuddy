import Foundation
import UIKit
import RealmSwift

class CreateRoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var routine: Routine?
    @IBOutlet weak var routineTableView: UITableView!
    @IBOutlet weak var routineNameLabel: UILabel!
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        let realm = try! Realm()
        guard let routineToSave = routine else { return }
        
//        try! realm.write {
//            realm.add(routineToSave)
//        }
//        
//        let saved = realm.objects(Routine.self)
        
//        print(saved)
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addWorkoutButtonWasPressed(_ sender: Any) {
        let newWorkout = Workout()
        routine?.workout.append(newWorkout)
        
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
            let lift = routine?.workout[indexPath.row]
        else { return UITableViewCell() }

        cell.workout = lift
        cell.numberOfSetsLabel.text = "Sets: \(String(describing: lift.lifts.count))"
        cell.workoutNameTextField.text = cell.name
        lift.name = cell.name
        
        guard let rest = lift.rest.value else { return cell }
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
        setLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.routineTableView.reloadData()
    }
    
    private func setLabels(){
        guard let routineName = routine?.name else { return }
        routineNameLabel.text = routineName
    }
}
