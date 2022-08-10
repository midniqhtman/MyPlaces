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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = restarauntNames[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "lasso")
        cell.imageView?.layer.cornerRadius =  cell.frame.size.height / 2
        
        cell.imageView?.clipsToBounds = true
    
        return cell
    }
    
    //MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

