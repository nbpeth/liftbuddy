import UIKit

class RestViewController: BaseViewController {
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    var timer:RestTimer!
    var restTime = 0
    var nextLift:LiftInProgress?
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.setProgress(Float(restTime), animated: false)
        restLabel.text = String(describing:restTime)
        timer = RestTimer(delegate:self, rest: restTime )
        timer.fireRestTimer()
    }
}
