import Foundation
import CocoaLumberjackSwift
// swiftlint:disable all

struct Responce: Decodable {
    let results: [CartoonCharacter]
}

struct CartoonCharacter: Decodable {
    let name: String
}

enum RickAndMortyAPIManager {
    static func printCharacters() async {
        let task = Task { () -> Responce? in
            guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
                DDLogError("\(URLError(.badURL))")
                return nil
            }
            
            do {
                let (data, _) = try await URLSession.shared.dataTask(for: URLRequest(url: url))
                
                let results = try JSONDecoder().decode(Responce.self, from: data)
    
                return results
            } catch {
                DDLogError("\(error)")
                return nil
            }
        }
        
        // Раскоментить что-бы таск отменилась
        
        // task.cancel()
        
        let responce = await task.value
        DDLogDebug("Responce: \(responce)")
    }
}
