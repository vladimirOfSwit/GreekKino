//
//  ResultsController.swift
//  GreekKino
//
//  Created by Vladimir Savic on 1/31/21.
//

import UIKit

class ResultsController: UIViewController {
    
    var currentDate = Date()
    var dateAsString = ""
    
    var resultsUrl = ""
    var winningNumbers = [WinningNumbers]()
    var finalNumbersArray = [[Int]]()
    var selectedNumbers = [Int]()
    
    
    @IBOutlet weak var winningNumbersLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        fetchResults()
        
        displayWinningNumbers()
        
    }
    
    
    
    
    
    //MARK: - Helper Functions
    
    
    func displayWinningNumbers() {
        
        let finalNumbers = Array(finalNumbersArray)
        
        print("RESULT: \(finalNumbers)")
        
        let result = finalNumbersArray.chunked(into: 20)
        
        print("RESULT: \(result)")
        //
        //    let array = finalNumbersArray.map(String.init).joined(separator: "")
        //        winningNumbersLabel.text = array
        
    }
    
    
    func createUrlForEndpoint(with date: String) {
        
        let finalUrl = "https://api.opap.gr/draws/v3.0/1100/draw-date/\(date)/\(date)"
        
        resultsUrl = finalUrl
        
        
        
    }
    
    
    func convertDateToString(date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let convertedDateToString = dateFormatter.string(from: date)
        
        dateAsString = convertedDateToString
        
    }
    
    
    
    //MARK: - API
    
    
    func fetchResults() {
        
        convertDateToString(date: currentDate)
        
        createUrlForEndpoint(with: dateAsString)
        
        
        
        guard let url = URL(string: resultsUrl) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error == nil && data != nil {
                
                let decoder = JSONDecoder()
                
                do {
                    let results = try decoder.decode(Root.self, from: data!)
                    
                    print("DEBUG: Selected numbers in Results VC are: \(self.selectedNumbers)")
                    
                    
                    
                    let contents = results.content
                    
                    for content in contents {
                        self.winningNumbers.append(content.winningNumbers)
                        print("DEBUG: \(content.winningNumbers.list)")
                        //self.finalNumbersArray.append(contentsOf: content.winningNumbers.list)
                        print("DEBUG: These are the finals: \(self.finalNumbersArray)")
                        
                    }
                    
                    let finalNumbers = Array(self.finalNumbersArray)
                    
                    print("RESULT: \(finalNumbers)")
                    
                    let result = self.finalNumbersArray.chunked(into: 20)
                    
                    DispatchQueue.main.async {
                        self.winningNumbersLabel.text = result.map(String.init).joined(separator: " ")
                    }
                    
                    
                    
                    print("RESULT: \(result)")
                    
                    
                } catch {
                    print("Parsing failed and this is why: \(error)")
                }
                
            }
            
        }
        task.resume()
        
    }
    
    
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
