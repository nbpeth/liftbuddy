import UIKit

class RestViewController: BaseViewController {
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var nextLiftNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!

    var timer:RestTimer!
    var restTime = 0
    var nextLift:LiftInProgress?
    
    @IBOutlet weak var liftSetPositionLabel: UILabel!
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.setProgress(Float(restTime), animated: false)
        restLabel.text = String(describing:restTime)
        timer = RestTimer(delegate:self, rest: restTime )
        timer.fireRestTimer()
        setLabels()
    }
    
    private func setLabels(){
        guard let nextLift = nextLift else { return }
        nextLiftNameLabel.text = nextLift.name
        
        repsLabel.text = String(describing:nextLift.reps.value ?? 0)
        weightLabel.text = "\(String(describing:nextLift.weight.value ?? 0)) lbs"

    }
}
