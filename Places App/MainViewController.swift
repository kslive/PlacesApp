//
//  MainViewController.swift
//  Places App
//
//  Created by Eugene Kiselev on 27.07.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    let places = Place.getPlaces()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = places[indexPath.row].name
        cell.typeLabel.text = places[indexPath.row].type
        cell.locationLabel.text = places[indexPath.row].location
        cell.imageOfPlaces.image =  UIImage(named: places[indexPath.row].image)
        cell.imageOfPlaces.layer.cornerRadius = cell.imageOfPlaces.frame.size.height / 2
        cell.imageOfPlaces.clipsToBounds = true
        
        return cell
    }
}
