//
//  TalonViewController.swift
//  GreekKino
//
//  Created by Vladimir Savic on 1/29/21.
//

import UIKit

class TalonViewController: UIViewController {
    
    
    //MARK: - Properties
    
    var upcomingDrawTime = ""
    var currentDrawId = 0
    var numbersSelectedArray = [Int]()
    let maxNumbers = 20
    var randomNumber = 0
    var maximumReached = false
    
    var currentTime = Date()
    
    var selectedDrawTime: Date?
    
    var timer = Timer()
    var timeCount: Int = 0
    
    var seconds = 0
    var minutes = 0
    var hours = 0
    var timeIsUp = false
    
    //MARK: - IBOutlets and IBActions
    
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    @IBAction func liveDrawButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "TalonToLive", sender: self)
        
    }
    
    @IBAction func resultsButtonPressed(_ sender: UIButton) {
        
        
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let resultsVC = segue.destination as! ResultsController
            
            resultsVC.selectedNumbers = numbersSelectedArray
            
            
        }
        
        
        performSegue(withIdentifier: "TalonToResults", sender: self)
        
        
        
        
    }
    
    
    @IBOutlet weak var currentNumbersSelectedLabel: UILabel!
    
    @IBOutlet weak var numbersCounter: UILabel!
    @IBOutlet weak var drawTime: UILabel!
    @IBOutlet weak var drawId: UILabel!
    
    
    
    @IBAction func resetAll(_ sender: UIButton) {
        
        numbersSelectedArray = [Int]()
        currentNumbersSelectedLabel.text = ""
        numbersCounter.text = ""
        
    }
    
    
    @IBOutlet weak var numbersSelectedShown: UILabel!
    
    
    
    
    @IBAction func randomNumberButtonPressed(_ sender: UIButton) {
        
        createAlertRandom()
        
    }
    
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if timeIsUp == true {
            
            alertIfTimeIsUp()
            
        } else {
            
            let button = sender
            
            appendToArray(number: sender.tag)
            displayNumbersInLabel()
            
            if maximumReached == false {
                
                UIView.transition(with: button, duration: 300.0, options: .transitionFlipFromTop) {
                    button.isHighlighted = true
                }
                
                
                
            }
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer()
        
        configureUI()
        
        
    }
    
    
    
    
    //MARK: - Helper functions
   
    
    func configureUI() {
        
        if let selectedDrawTime = selectedDrawTime {
            
            drawId.text = String(currentDrawId)
            drawTime.text = DateFormatter().formatDate(date: selectedDrawTime)
            
            
            
        }
        
        
    }
    
    
    func startTimer() {
        
        
        
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(TalonViewController.updateTimeLeftLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        
        
    }
    
    
    @objc func updateTimeLeftLabel() {
        
        
        
        timeCount += 1
        
        if let selectedDrawTime = self.selectedDrawTime {
            let hours = Int(selectedDrawTime.timeIntervalSinceNow) / 3600
            self.hours = hours
            let minutes = Int(selectedDrawTime.timeIntervalSinceNow) / 60 % 60
            self.minutes = minutes
            let seconds = Int(selectedDrawTime.timeIntervalSinceNow) % 60
            self.seconds = seconds
            let formattedString = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            self.timeLeftLabel.text = formattedString
        }
        
        
        
        
        
        
        if seconds == 0 && minutes == 0 && hours == 0 {
            timeLeftLabel.text = "Vreme je isteklo. Rezultati kola \(drawId.text!) su izvučeni"
            self.timeIsUp = true
            timer.invalidate()
            
        }
        
    }
    
    func displayNumbersInLabel() {
        
        let array = numbersSelectedArray.map(String.init).joined(separator: " ")
        currentNumbersSelectedLabel.text = array
        
    }
    
    
    
    func appendToArray(number: Int) {
        
        if numbersSelectedArray.count < maxNumbers && maximumReached == false {
            numbersSelectedArray.append(number)
            numbersCounter.text = String(numbersSelectedArray.count)
            
        }  else  {
            maximumReached = true
            createMaxNumAlert()
            
            
        }
        
    }
    
    
    func alertIfTimeIsUp() {
        
        let alert = UIAlertController(title: "Obaveštenje", message: "Vreme je isteklo, molimo pogledajte rezultate izvlačenja.", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func createMaxNumAlert() {
        
        let alert = UIAlertController(title: "Obaveštenje", message: "Ispunili ste maksimum izabranih brojeva.", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func createAlertRandom() {
        
        
        let randomNumber = Int(arc4random_uniform(81))
        
        self.randomNumber = randomNumber
        
        let alert = UIAlertController(title: "Nasumični broj", message: "Vaš nasumični broj je: \(randomNumber)", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Ponovi", style: .default) { [self] (UIAlertAction) in
            appendToArray(number: self.randomNumber)
            
        }
        
        alert.addAction(restartAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}





