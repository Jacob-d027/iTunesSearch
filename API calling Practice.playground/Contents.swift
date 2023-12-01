import UIKit
import Foundation

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
}

func fetchPhotoInfo() -> PhotoInfo {
    
}

func dateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}

extension Date {
    var apiKeyValue: String {
        dateFormatter().string(from: self)
    }
}

// construct a url
let podBaseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
// create query parameters
var constructedURL = podBaseURL
let date = Date()
let dateQueryItem = URLQueryItem(name: "date", value: date.apiKeyValue)
let qpiKeyQueryItem = URLQueryItem(name: "api_key", value: "UUgySDnSlNxVdPMMHPbuqvfNPfogHJy6NSSMIWnl")
// add query items to url
constructedURL.append(queryItems: [dateQueryItem, qpiKeyQueryItem])
print(constructedURL)

// create a task to run async code
Task {
    do {
        // fetch data at the url
        let (data, _) = try await URLSession.shared.data(from: constructedURL)
        // use the data to do what you want
        let stringRepresentation = String(data: data, encoding: .utf8)
        print(stringRepresentation)
        
        
    } catch {
        print("an error must have occured: \(error.localizedDescription)")
    }
}


