import UIKit
import RealmSwift

class RoutineListTableViewController: BaseTableViewController {
    var routines = [Routine]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        routines = RoutineManager.getAllRoutines()
        
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

        cell.routineNameLabel.text = routines[indexPath.row].name
        cell.routineNameLabel.textColor = Theme.textColor
        cell.backgroundColor = Theme.cellBackgroundColor

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
