//
//  TableViewController.swift
//  MAD_Ind04_Peram_Venkata_Ramana_Reddy
//
//  Created by OSU APP CENTER on 4/22/24.
//

import UIKit

class TableViewController: UITableViewController {

    var statesData: [(stateName: String, nickName: String)] = []
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        setupActivityIndicator()
        fetchDataFromServer()
    }

    func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        //self.tableView.isHidden = true
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        self.tableView.isHidden = false
    }
    
    func fetchDataFromServer() {
        startLoading()
        
        let url = URL(string: "https://cs.okstate.edu/~vperam/us_states.php")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                self.stopLoading()
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                    self.statesData = jsonArray.map { item in
                        let name = item["name"] ?? ""
                        let nickname = item["nickname"] ?? ""
                        return (stateName: name, nickName: nickname)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.stopLoading()
                    }
                } else if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let message = jsonDict["message"] as? String {
                    print(message)
                    self.stopLoading()
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                self.stopLoading()
            }
        }.resume()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statesData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let state = statesData[indexPath.row]
        
        cell.textLabel?.text = state.stateName
        cell.detailTextLabel?.text = state.nickName
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
