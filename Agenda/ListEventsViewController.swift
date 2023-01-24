//
//  ListEventsViewController.swift
//  Agenda
//
//  Created by Apps2M on 17/1/23.
//

import UIKit

class ListEventsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        executeAPI()
        super.viewDidLoad()
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // Formatea la fecha
        let timeInterval = TimeInterval(ListEvents[indexPath.row].dateEvent / 1000)
        let myNSDate = Date(timeIntervalSince1970: timeInterval)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = ListEvents[indexPath.row].nameEvent + "\n" + myNSDate.formatted(date: .abbreviated, time: .standard).description

        return cell
    }
    
    func executeAPI() {
        let url = URL(string: "https://superapi.netlify.app/api/db/eventos")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data {
                let events = try? JSONSerialization.jsonObject(with: data)
                for i in events as! [[String:Any]]{
                    let newEvent = Event(json:i)
                    
                    ListEvents.append(newEvent)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.tableView.reloadData()
                }
            }
            
        }.resume()
    }
    
    // Vacía el array de eventos, vuelve a hacer la llamada para obtener los datos y lo rellena de nuevo actualizado
    @IBAction func btnActualizar_OnClick(_ sender: Any) {
        ListEvents = []
        executeAPI()
    }
}


