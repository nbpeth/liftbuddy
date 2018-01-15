import UIKit

protocol TableCellSelectorDelegate {
    func selectedCell(value:String)
}

class ExerciseDefinitionTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var exerciseDefinitions = [ExerciseDefinition]()
    var delegate: TableCellSelectorDelegate?

    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        searchBar.delegate = self
        fetchExerciseDefinitions()
        self.tableView.tableHeaderView = searchBar
        self.tableView.reloadData()
    }
    
    func fetchExerciseDefinitions(){
        exerciseDefinitions = ExerciseDefinitionManager.getAllExercisesSorted()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            exerciseDefinitions = ExerciseDefinitionManager.getAllExercisesSorted()
        }
        else {
            exerciseDefinitions = ExerciseDefinitionManager.searchFor(searchText)
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseDefinitions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(value: exerciseDefinitions[indexPath.row].name ?? "uh oh")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        let letters = exerciseDefinitions.map({ (e:ExerciseDefinition) -> String in
//            guard let name = e.name else { return "" }
//            return String(name[name.index(name.startIndex, offsetBy: 1) ])
//        })
//
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseDefinitionCell") as? ExerciseDefinitionCell else { return ExerciseDefinitionCell() }
        
        cell.nameLabel?.text = exerciseDefinitions[indexPath.row].name
        cell.backgroundColor = Theme.inactiveCellColor
        cell.nameLabel?.textColor = Theme.linkBlue
        
        return cell
    }
    
}
