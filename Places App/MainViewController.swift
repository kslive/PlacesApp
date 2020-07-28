//
//  MainViewController.swift
//  Places App
//
//  Created by Eugene Kiselev on 27.07.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    var places = Place.getPlaces()

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
        
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.typeLabel.text = place.type
        cell.locationLabel.text = place.location
        
        if place.image == nil {
            cell.imageOfPlaces.image =  UIImage(named: place.placesImage!)
        } else {
            cell.imageOfPlaces.image = place.image
        }
        
        
        cell.imageOfPlaces.layer.cornerRadius = cell.imageOfPlaces.frame.size.height / 2
        cell.imageOfPlaces.clipsToBounds = true
        
        return cell
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {

        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        
        newPlaceVC.saveNewPlace()
        places.append(newPlaceVC.newPlace!)
        
        tableView.reloadData()
    }
}
