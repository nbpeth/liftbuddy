import UIKit
import Foundation
import RealmSwift

class CreateOrEditWorkoutViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var workoutNameTextField: UITextField!
//    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var editSetsButton: UIButton!
    @IBOutlet weak var exerciseNameTableView: UITableView!
    @IBOutlet weak var muscleGroupTableView: UITableView!
    var workout:Workout?
    var allExercises = [ExerciseDefinition]()
    var groups = [String]()
    var exerciseNames = [String]()
    
    
    @IBAction func workoutNameEditingChanged(_ sender: Any) {
        setWorkoutName()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        workoutNameTextField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let setsCount = workout?.lifts.count else { return }
        
        workoutNameTextField.text = workout?.name ?? ""
//        setsLabel.text = String(describing:setsCount)
        
        setButtonEnabledStatus()
        getGroups()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSetsToWorkoutSegue", let destination = segue.destination as? EditWorkoutViewController {
            destination.workout = workout
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.muscleGroupTableView {
            return groups.count
        }
        else {
            return exerciseNames.count
        }
    }
    
    //move table delegates outside of viewcontroller, you know, when you feel like it.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.muscleGroupTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? LiftGroupLabelCell else { return LiftGroupLabelCell() }
            cell.liftGroupLabel.text = groups[indexPath.row]
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "muscleGroupCell") as? MuslcleGroupTableCell else { return MuslcleGroupTableCell() }
            cell.muscleGroupLabel.text = exerciseNames[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.muscleGroupTableView {
            let selectedGroup = groups[indexPath.row]
            exerciseNames = allExercises.filter {$0.muscleGroup ?? "" == selectedGroup }.map{$0.name ?? ""}
            
            self.exerciseNameTableView.reloadData()

        }
        else if tableView == self.exerciseNameTableView {
            let selectedExercise = exerciseNames[indexPath.row]
            self.workoutNameTextField.text = selectedExercise
            
            setWorkoutName()
            
        }
        
    }
    
    private func getGroups(){
        self.allExercises = RealmManager().realm.objects(ExerciseDefinition.self).map { $0 }
        
        self.groups = allExercises.map { $0.muscleGroup ?? "" }
            .reduce(into: [String](), { res, next in
            if res.index(of: next) == nil {
                res.append(next)
            }
        })
        
        self.muscleGroupTableView.reloadData()
    }
    
    private func setDelegates() {
        workoutNameTextField.delegate = self
        exerciseNameTableView.delegate = self
        exerciseNameTableView.dataSource = self
        muscleGroupTableView.delegate = self
        muscleGroupTableView.dataSource = self
    }
    
    private func setButtonEnabledStatus(){
        guard let name = workoutNameTextField.text else { return }
        if name.count > 0 {
            editSetsButton.isEnabled = true
        }
        else {
            editSetsButton.isEnabled = false
        }
    }
    
    private func setWorkoutName(){
        guard let workout = workout, let name = workoutNameTextField.text else { return }
        setButtonEnabledStatus()
        workout.name = name
    }
}
