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

        
        
        self.dismiss(animated: true, completion: nil)
    }
    


}
