//
//  SignInViewController.swift
//  Agenda
//
//  Created by Apps2M on 18/1/23.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func SignIn_OnClick(_ sender: Any) {
        if (txtName.text == ""){
            txtName.backgroundColor = .systemRed
            return
        }
        if (txtPass.text == ""){
            txtPass.backgroundColor = .systemRed
            return
        }
        POSTUser()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func POSTUser() {
        let parameters: [String: Any] = [
            "user": txtName.text,
            "pass": txtPass.text]
        
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
