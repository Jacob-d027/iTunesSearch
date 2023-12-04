import UIKit

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [SearchItem]
    
    enum ResultsCodingKey: CodingKey {
        case results
        case resultCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultsCodingKey.self)
        self.resultCount = try container.decode(Int.self, forKey: .resultCount)
        self.results = try container.decode([SearchItem].self, forKey: .results)
    }
    
}

enum SearchResultError: Error, LocalizedError {
    case itemNotFound
}

struct SearchItem: Decodable {
    let artistName: String
    let albumName: String
    let trackName: String
    let kind: String
    
    enum SearchItemCodingKey: String, CodingKey {
        case artistName
        case albumName = "collectionName"
        case trackName
        case kind
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SearchItemCodingKey.self)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.albumName = try container.decode(String.self, forKey: .albumName)
        self.trackName = try container.decode(String.self, forKey: .trackName)
        self.kind = try container.decode(String.self, forKey: .kind)
    }
}

    func fetchItems(matching query: [String: String]) async throws -> [SearchItem] {

        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.queryItems = query.map( { URLQueryItem(name: $0.key, value: $0.value ) } )
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SearchResultError.itemNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let searchResult = try jsonDecoder.decode(SearchResult.self, from: data)
            
            
        return searchResult.results
    }


var query: [String: String] = ["term": "EDEN", "media": "music", "limit": "5"]

Task {
    do {
        let searchItems = try await fetchItems(matching: query)
        searchItems.forEach({ item in
            print("""
        Name: \(item.trackName)
        Artist: \(item.artistName)
        Album: \(item.albumName)
        
        
        """)
        })
    } catch {
        print(error)
    }
}

