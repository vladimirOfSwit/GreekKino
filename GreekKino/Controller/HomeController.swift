//
//  ViewController.swift
//  GreekKino
//
//  Created by Vladimir Savic on 1/27/21.
//

import UIKit

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    let drawUrl = "https://api.opap.gr/draws/v3.0/1100/upcoming/20"
    let reuseIdentifier = "cell"
    
    var upcomingDrawsArray = [String]()
    var timeLeftArray = [String]()
    var drawIdArray = [Int]()
    
    
    var newTimeArrayRaw = [Date]()
    var newTime: Date?
    
    var currentTimeRaw = Date()
    var selectedDrawTime: Date? = nil
    
    //MARK: - IB outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftLabel: UILabel!
    
    
    
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        registerTableViewCell()
        
        
        fetchDraws()
        
        
        
        
    }
    
    
    
    
    //MARK: - Helper functions
    
    
    func calculateCurrentDrawTimeLeft(drawTimeSelected: Date, currentTime: Date) {
        
        let difference = Calendar.current.dateComponents([.minute, .second], from: drawTimeSelected, to: currentTime)
        var formattedString = String(format: "%02ld%02ld", difference.minute!, difference.second!)
        let index = formattedString.index(formattedString.startIndex, offsetBy: 2)
        formattedString.insert(":", at: index)
        
        print("DEBUG: Current time left is: \(formattedString)")
        
    }
    
    
    
    func calculateRemainingTime() {
    
        for upcomingTime in newTimeArrayRaw {
            
            
            let difference = Calendar.current.dateComponents([.minute, .second], from: self.currentTimeRaw, to: upcomingTime)
            var formattedString = String(format: "%02ld%02ld", difference.minute!, difference.second!)
            let index = formattedString.index(formattedString.startIndex, offsetBy: 2)
            formattedString.insert(":", at: index)
            timeLeftArray.append(formattedString)
            
            
        }
        
        
    }
    
    private func registerTableViewCell() {
        let drawCell = UINib(nibName: "DrawTableViewCell", bundle: nil)
        self.tableView.register(drawCell, forCellReuseIdentifier: "cell")
    }
    
    
    
    //MARK: - API
    
    func fetchDraws() {
        
        guard let url = URL(string: drawUrl) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
           
            if error == nil && data != nil {
            
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                
                
                do {
                    let results = try decoder.decode([Draw].self, from: data!)
                    
                    
                    
                    for draw in results {
                        
                        self.newTimeArrayRaw.append(draw.drawTime)
                        let newTime = DateFormatter().formatDate(date: draw.drawTime)
                        let newDate = self.newTimeArrayRaw[0]
                        self.newTime = newDate
                        self.upcomingDrawsArray.append(newTime)
                        self.drawIdArray.append(draw.drawId)
                        
                        
                    }
                    
                    
                    self.calculateRemainingTime()
                    
                    print("DEBUG: This is the array of upcoming draws in the formatted time: \(self.upcomingDrawsArray)")
                    print("DEBUG: This is the array of the draw id of the upcoming draws: \(self.drawIdArray)")
                    print("DEBUG: This is the array of time left: \(self.timeLeftArray)")
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                    
                    
                } catch {
                    print("Parsing failed and this is why: \(error)")
                }
                
            }
            
        }
        task.resume()
        
    }
    
    
    
}


//MARK: - TableViewDelegate and TableViewSource




extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingDrawsArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DrawTableViewCell
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.leftLabel.text = upcomingDrawsArray[indexPath.row]
        cell.rightLabel.text = timeLeftArray[indexPath.row]
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Naredno kolo                                     Preostalo:"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let talonVC = segue.destination as! TalonViewController
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! DrawTableViewCell
        
        guard let selectedDrawTime = currentCell.leftLabel.text else { return }
       
        let currentDrawId = self.drawIdArray[indexPath.row]
        self.selectedDrawTime = newTimeArrayRaw[indexPath.row]
       
        talonVC.upcomingDrawTime = selectedDrawTime
        talonVC.currentDrawId = currentDrawId
        talonVC.selectedDrawTime = self.newTimeArrayRaw[indexPath.row]
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "HomeToTalon", sender: self)
        
    }
    
    
    
}




//MARK: - Extensions



public extension DateFormatter {
    
    func formatDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.timeZone = TimeZone(secondsFromGMT: 3600)
        formatter.dateFormat = "HH:mm"
        
        let finalTime = formatter.string(from: date)
        
        return finalTime
    }
    
}




