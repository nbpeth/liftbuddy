import UIKit

class ListOfWorkoutsViewController: UIViewController, TableCellSelectorDelegate {

    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var embeddedExerciseDefinitionTable: UIViewController!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var workout:WorkoutInProgress?

    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donebuttonWasPressed(_ sender: Any) {
        guard let newName = workoutNameTextField.text, let workout = workout else { return }
        changeWorkoutNameTo(newName, workout: workout)
        saveExerciseDefinitionIfNotExists(exerciseName: newName)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolBar.barTintColor = Theme.tabBarColor
        
        guard let workout = workout else { return }
        workoutNameTextField.text = workout.name
        
    }
    
    func selectedCell(value:String) {
        workoutNameTextField.text = value
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embeddedExerciseDefinitionTable" {
            guard let destination = segue.destination as? ExerciseDefinitionTableViewController else { return }
            destination.delegate = self
        }
    }
    
    private func changeWorkoutNameTo(_ newName:String, workout:WorkoutInProgress){
        workout.name = newName
        for lift in workout.lifts {
            lift.name = newName
        }
    }
    
    private func saveExerciseDefinitionIfNotExists(exerciseName:String){
        let matchedExercise = ExerciseDefinitionManager.getAllExercises().filter {$0.name == exerciseName}
        if matchedExercise.count <= 0 {
            RealmManager.shared.beginWrite()
            ExerciseDefinitionManager.saveCustomExerciseDefinition(exerciseDefinitions: [exerciseName])
            RealmManager.shared.saveChanges()
        }
    }
    
}

