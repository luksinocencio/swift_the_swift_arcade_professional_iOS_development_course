import Foundation
import UIKit

struct Account: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Double
    let createdDateTime: Date
    
    static func makeSkeleton() -> Account {
        return Account(id: "`", type: .Banking, name: "Account name", amount: 0.0, createdDateTime: Date())
    }
}

extension AccountSummaryViewController {
    func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account],NetworkError>) -> Void) {
        guard let url = URL(
            string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)/accounts"
        ) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let accounts = try decoder.decode([Account].self, from: data)
                    completion(.success(accounts))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
