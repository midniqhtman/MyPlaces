//
//  ViewController.swift
//  MyPlaces
//
//  Created by Байсаев Зубайр on 10.08.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    let restarauntNames = [
    "Coffetown", "Steakhouse", "CFC", "Foodinbox", "Samburger",
    "Kannamchicken", "Chickenhut", "Tbiliso", "Drinks"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restarauntNames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel?.text = restarauntNames[indexPath.row]
        cell.imageOfPlace?.image = UIImage(systemName: "lasso")
        cell.imageOfPlace?.layer.cornerRadius =  cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace?.clipsToBounds = true
    
        return cell
    }
    
    //MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

