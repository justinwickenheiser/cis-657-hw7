//
//  ViewController.swift
//  hw3
//
//  Created by Justin Wickenheiser & Nathan Hull on 5/15/18.
//  Copyright © 2018 Justin Wickenheiser & Nathan Hull. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var latP1: DecimalMinusTextField!
    @IBOutlet weak var longP1: DecimalMinusTextField!
    @IBOutlet weak var latP2: DecimalMinusTextField!
    @IBOutlet weak var longP2: DecimalMinusTextField!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var bearing: UILabel!
    
	var entries : [LocationLookup] = [
		LocationLookup(origLat: 90.0, origLng: 0.0, destLat: -90.0, destLng: 0.0,
					   timestamp: Date.distantPast),
		LocationLookup(origLat: -90.0, origLng: 0.0, destLat: 90.0, destLng: 0.0,
					   timestamp: Date.distantFuture)]
	var distanceUnits = "Kilometers"
	var degreeUnits = "Degrees"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = BACKGROUND_COLOR
        
        // dismiss keyboard when tapping outside of text fields
        let detectTouch = UITapGestureRecognizer(target: self, action:
            #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Simple function to dismiss keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func calculate(_ sender: Any) {
		let loc1 = CLLocation(latitude: CLLocationDegrees((latP1.text! as NSString).doubleValue), longitude: CLLocationDegrees((longP1.text! as NSString).doubleValue))
		let loc2 = CLLocation(latitude: CLLocationDegrees((latP2.text! as NSString).doubleValue), longitude: CLLocationDegrees((longP2.text! as NSString).doubleValue))
        
        // Store the lat/longs of the two points
        entries.append(LocationLookup(origLat: loc1.coordinate.latitude, origLng: loc1.coordinate.longitude, destLat: loc2.coordinate.latitude, destLng: loc2.coordinate.longitude, timestamp: loc1.timestamp))
		
        // Distance
        let distInMeters = loc1.distance(from:loc2)
        let distInKm = distInMeters/1000
        if distanceUnits == "Kilometers" {
            distance.text = "Distance: \(String(format:"%.2f",distInKm)) \(distanceUnits)"
        } else {
            let distInMiles = distInKm * 0.621371
            distance.text = "Distance: \(String(format:"%.2f",distInMiles)) \(distanceUnits)"
        }
		
		// Bearing
        let bearingInDegrees = loc1.bearingToPoint(point:loc2);
        if degreeUnits == "Degrees" {
            bearing.text = "Bearing: \(String(format:"%.2f", bearingInDegrees)) \(degreeUnits)"
        } else {
            let bearingInMils = bearingInDegrees * 17.777777777778
            bearing.text = "Bearing: \(String(format:"%.2f", bearingInMils)) \(degreeUnits)"
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        latP1.text = ""
        longP1.text = ""
        latP2.text = ""
        longP2.text = ""
        distance.text = "Distance:"
        bearing.text = "Bearing:"
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "settingsSegue" {
			if let destVC = segue.destination as? SettingsViewController {
				destVC.distanceUnits = self.distanceUnits
				destVC.degreeUnits = self.degreeUnits
                // set my(self) as the delegate in the destination
                destVC.delegate = self
			}
        } else if segue.identifier == "historySegue" {
            if let destVC = segue.destination as? HistoryTableViewController {
                destVC.entries = self.entries
				destVC.historyDelegate = self
            }
        }
	}
}

extension ViewController: SettingsViewControllerDelegate, HistoryTableViewControllerDelegate {
    func settingsChanged(distanceUnits: String, bearingUnits: String) {
        // set the units
        self.distanceUnits = distanceUnits
        self.degreeUnits = bearingUnits
        // recalculate
        self.calculate(self)
    }
	
	func selectEntry(entry: LocationLookup) {
		latP1.text = "\(entry.origLat)"
		longP1.text = "\(entry.origLng)"
		latP2.text = "\(entry.destLat)"
		longP2.text = "\(entry.destLng)"
		
		self.calculate(self)
	}
}
