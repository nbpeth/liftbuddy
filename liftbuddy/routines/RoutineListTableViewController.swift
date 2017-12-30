import UIKit
import RealmSwift

class RoutineListTableViewController: BaseTableViewController {
    var routines = [Routine]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = Theme.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        routines = RoutineManager.getAllRoutines()
        displayNoRoutinesLabel()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as? RoutineTableViewCell else { return UITableViewCell() }

        let routine = routines[indexPath.row]
        if let lastCompletedDate = routine.lastCompletedDate {
            cell.lastCompletedLabel.text = DateUtils.formatMMDDYYYY(date: lastCompletedDate )
        }
        else{
            cell.lastCompletedLabel.text = " - "
            cell.lastCompletedLabel.textColor = .red
        }
        
        cell.routineNameLabel.text = routine.name
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Theme.cellSelectedBackgroundColor.withAlphaComponent(0.8)
        }
        else {
            cell.backgroundColor = Theme.alternateCellSelectedBackgroundColor.withAlphaComponent(0.8)

        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                        
            try! realm.write {
                realm.delete(routines[indexPath.row])
            }
            routines.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            displayNoRoutinesLabel()
            
        }
    }
    
    func displayNoRoutinesLabel(){
        let noRoutinesLabel1 = UILabel()
        let noRoutinesLabel2 = UILabel()

        if routines.count <= 0 {
            noRoutinesLabel1.frame = CGRect(x: 0, y: (self.view.frame.height/2)-90, width: self.view.frame.width - 20, height: 50)
            noRoutinesLabel1.textColor = .white
            noRoutinesLabel1.textAlignment = .center
            noRoutinesLabel1.text = "You have no routines yet"
            self.view.addSubview(noRoutinesLabel1)
            
            noRoutinesLabel2.frame = CGRect(x: 0, y: (self.view.frame.height/2)-65, width: self.view.frame.width - 20, height: 50)
            noRoutinesLabel2.textColor = .white
            noRoutinesLabel2.textAlignment = .center
            noRoutinesLabel2.text = "Tap create to get started!"
            self.view.addSubview(noRoutinesLabel2)
        }
        else {
            noRoutinesLabel1.removeFromSuperview()
            noRoutinesLabel2.removeFromSuperview()

        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destination = storyboard.instantiateViewController(withIdentifier: "RoutineDetailViewController") as? RoutineDetailViewController {
            let routine = routines[indexPath.row]
            
            destination.routineId = routine.id
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

}
