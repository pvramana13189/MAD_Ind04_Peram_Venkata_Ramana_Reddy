//
//  ViewController.swift
//  MAD_Ind04_Peram_Venkata_Ramana_Reddy
//
//  Created by OSU APP CENTER on 4/20/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableData: UITableView!
    var statesData: [(stateName: String, nickName: String)] = []
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupActivityIndicator()
        fetchDataFromServer()
    }
    
    func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        tableData.isHidden = true
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        tableData.isHidden = false
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
                        self.tableData.reloadData()
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
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let state = statesData[indexPath.row]
        
        cell.textLabel?.text = state.stateName
        cell.detailTextLabel?.text = state.nickName
        
        return cell
    }
}

