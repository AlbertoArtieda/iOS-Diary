
import UIKit

class Event: Codable {
    public var nameEvent: String
    public var dateEvent: Double
    
    init(json: [String: Any]) {
    nameEvent = json["name"] as? String ?? ""
    dateEvent = json["date"] as? Double ?? 0
    }
    
}

var ListEvents: [Event] = []

class NewEventViewController: UIViewController {
    @IBOutlet weak var txtNameEvent: UITextField!
    @IBOutlet weak var DateNewEvent: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SaveEvent(_ sender: Any) {
        if (txtNameEvent.text == ""){
            txtNameEvent.backgroundColor = .systemRed
            return
        }
        POSTEvent()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func POSTEvent() {
        let parameters: [String: Any] = [
            "name": txtNameEvent.text,
            "date": Double(DateNewEvent.date.timeIntervalSince1970)]
        let url = URL(string: "https://superapi.netlify.app/api/db/eventos")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
          
          do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          } catch let error {
            print(error.localizedDescription)
            return
          }
          let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
              print("Post Request Error: \(error.localizedDescription)")
              return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
              print("Invalid Response received from the server")
              return
            }
            guard let responseData = data else {
              print("nil Data received from the server")
              return
            }
            
            do {
              if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                print(jsonResponse)
              } else {
                print("data maybe corrupted or in wrong format")
                throw URLError(.badServerResponse)
              }
            } catch let error {
              print(error.localizedDescription)
            }
          }
          task.resume()
    }
}
