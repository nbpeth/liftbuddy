import Foundation
import UIKit

class EditRoutineViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var routine: Routine?
    var routineId: Int?
    var editButton:UIBarButtonItem!
    
    @IBOutlet weak var routineTableView: UITableView!
    @IBOutlet weak var routineNameLabel: UILabel!
    @IBOutlet weak var routineNameTextField: UITextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBAction func routineNameTextFieldChanged(_ sender: Any) {
        guard let routine = routine, let routineName = routineNameTextField.text else { return }
        routine.name = routineName
        self.routine = routine
    }
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        
        saveCustomWorkouts()
        RealmManager.shared.saveChanges()
        navigateRoutineList()
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        RealmManager.shared.discardChanges()
        navigateRoutineList()
    }
    
    @IBAction func addWorkoutButtonWasPressed(_ sender: Any) {
        guard let routineId = routineId else { return }
        routine?.addWorkout(id: routineId)
        
        self.routineTableView.reloadData()
    }
    
    private func setEditingButton(){
        editButton = UIBarButtonItem(title: titleForEditButton(), style: .plain, target: self, action: #selector(toggleTableEditing))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func toggleTableEditing(){
        self.routineTableView.isEditing = self.routineTableView.isEditing ? false : true
        self.editButton.title = titleForEditButton()
    }
    
    private func titleForEditButton() -> String {
        return self.routineTableView.isEditing ? "Done Editing" : "Edit"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealmManager.shared.beginWrite()
        
        setEditingButton()
        setDelegates()
        setTheme()
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let routine = routine else { return }
        let sourceWorkout = routine.workout[sourceIndexPath.row]
        let destinationWorkout = routine.workout[destinationIndexPath.row]
        
        routine.workout[sourceIndexPath.row] = destinationWorkout
        routine.workout[destinationIndexPath.row] = sourceWorkout
        
        self.routineTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            guard let routineToDeleteFrom = routine else { return }
            
            if routineToDeleteFrom.workout.count >= indexPath.row  {
                routineToDeleteFrom.workout.remove(at: indexPath.row)
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
        cell.workoutNameLabel.text = workout.name
        cell.restTextField.text = String(describing: workout.rest.value ?? 0)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
        }
        else {
            cell.backgroundColor = Theme.alternateCellSelectedBackgroundColor.withAlphaComponent(0.8)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let destination = storyboard.instantiateViewController(withIdentifier: "CreateOrEditWorkoutViewController") as? CreateOrEditWorkoutViewController, let workout = routine?.workout[indexPath.row] {
            
            destination.workout = workout
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    private func navigateRoutineList(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newRoot = storyBoard.instantiateViewController(withIdentifier: "RoutineListTableViewController")
        self.navigationController?.setViewControllers([newRoot], animated: true)
    }

    private func setRoutine(){
        guard let id = routineId,
            let existingRoutine = RoutineManager.getRoutineBy(id: id)
        else {
            //create new routine
            if let routine = routine {
                routineId = routine.id                
                RoutineManager.create(routine: routine)
                setLabels()
                return
            }
            else{
                return
            }
        }
        //managing existing routine
        
        self.routine = existingRoutine
        
        setLabels()

    }
    
    private func setLabels(){
        guard let routineName = routine?.name else { return }
        routineNameTextField.text = routineName
    }
    
    private func setDelegates(){
        routineTableView.delegate = self
        routineTableView.dataSource = self
    }
    
    private func setTheme(){
        self.routineTableView.backgroundColor = Theme.inactiveCellColor
        self.headerView.backgroundColor = Theme.backgroundColor
        self.toolbar.barTintColor = Theme.tabBarColor
    }
    
    //until an exercise manager is implemented later
    private func saveCustomWorkouts(){
        guard let routine = routine else { return }
        let workoutNamesFromStore:[String] = ExerciseDefinitionManager.getAllExercises().map{$0.name ?? ""}
        let workoutNamesFromThisRoutine:[String] = routine.workout.map { $0.name }
        
        let unmatchedWorkouts = workoutNamesFromThisRoutine.filter { !workoutNamesFromStore.contains($0) && $0 != "New Lift" }
        
        ExerciseDefinitionManager.saveCustomExerciseDefinition(exerciseDefinitions:unmatchedWorkouts)
    
    }
}
