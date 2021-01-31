import Foundation

struct Root: Codable {
    let content: [Content]
    
}

struct Content: Codable {
    let winningNumbers: WinningNumbers
}

struct WinningNumbers: Codable {
    let list: [Int]
}


