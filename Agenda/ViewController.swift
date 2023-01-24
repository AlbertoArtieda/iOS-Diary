//
//  ViewController.swift
//  Agenda
//
//  Created by Apps2M on 12/1/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtUSUARIO: UITextField!
    @IBOutlet weak var txtPASS: UITextField!
    @IBOutlet weak var mensaje: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mensaje.isHidden = true
    }

    @IBAction func btnENTRAR_OnClick(_ sender: Any) {
        // Si el nombre o la contraseña están vacíos muestra un mensaje e impide acceder
        if (txtUSUARIO.text == "" || txtPASS.text == ""){
            mensaje.isHidden = false
            return
        }
        
        guard let url =  URL(string:"https://superapi.netlify.app/api/login")
                else{
                    return
                }
        let body: [String: String] = ["user": txtUSUARIO.text ?? "", "pass": txtPASS.text ?? ""]
                let finalBody = try? JSONSerialization.data(withJSONObject: body)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = finalBody
                
                URLSession.shared.dataTask(with: request){
                    (data, response, error) in
                    print(response as Any)
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let data = data else{
                        return
                    }
                    // Si el mensaje que devuelve es correcto accede a la app
                    if (String(data: data, encoding: .utf8) == "Login succesful"){
                        DispatchQueue.main.sync{
                            self.performSegue(withIdentifier: "GoToList", sender: sender)
                        }
                        
                    }
                    else {
                        self.mensaje.isHidden = false
                    }
                    
                }.resume()
        
    }
    
}
