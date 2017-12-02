import UIKit

class RestViewController: UIViewController {
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var timer:RestTimer!
    var restTime = 0
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restLabel.text = String(describing:restTime)
        timer = RestTimer(delegate:self, rest: restTime )
        timer.fireRestTimer()
    }
    
}
