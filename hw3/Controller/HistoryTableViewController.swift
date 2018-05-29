//
//  HistoryTableViewController.swift
//  hw3
//
//  Created by Justin Wickenheiser & Nathan Hull on 5/29/18.
//  Copyright © 2018 Justin Wickenheiser& Nathan Hull. All rights reserved.
//

import UIKit

protocol HistoryTableViewControllerDelegate {
	func selectEntry(entry: LocationLookup)
}

class HistoryTableViewController: UITableViewController {
    
    var entries: [LocationLookup] = []
	var historyDelegate:HistoryTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "\(round(10000*self.entries[indexPath.row].origLat)/10000), \(round(10000*self.entries[indexPath.row].origLng)/10000)"
        cell.detailTextLabel?.text = "\(round(10000*self.entries[indexPath.row].destLat)/10000), \(round(10000*self.entries[indexPath.row].destLng)/10000)"

        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
		IndexPath) {
		
		// use the historyDelegate to report back entry selected to the calculator scene
		if let del = self.historyDelegate {
			let ll = entries[indexPath.row]
			del.selectEntry(entry: ll)
		}
		// this pops to the calculator
		_ = self.navigationController?.popViewController(animated: true)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
