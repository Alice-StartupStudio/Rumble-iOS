//
//  MealTableViewController.swift
//  Rumble
//
//  Created by Yanbo Li on 3/27/17.
//  Copyright © 2017 Yanbo Li. All rights reserved.
//

import UIKit
import os.log
import WatchConnectivity

// Properties

var meals = [Meal]()

class MealTableViewController: UITableViewController, WCSessionDelegate {
    
//    var connectivityHandler : ConnectivityHandler!
    var session : WCSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGray
        
//        UINavigationBar.appearance().tintColor = uicolorFromHex(0x76AB39)
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        }
        
//        self.connectivityHandler = (UIApplication.shared.delegate as? AppDelegate)?.connectivityHandler
//        self.connectivityHandler?.addObserver(self, forKeyPath: "messages", options: [], context: nil)


        if let savedMeals = loadMeals() {
            meals += savedMeals
        }else {
            // Load the sample data
            loadSampleMeals()
        }
        printMessagesForUser()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // Watch Connection Session
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("%@", "sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("%@", "sessionDidDeactivate: \(session)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        NSLog("%@", "sessionWatchStateDidChange: \(session)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        NSLog("didReceiveMessage: %@", message)
        var name = "Migraine"
        var photo = UIImage(named: "migraine")
        DispatchQueue.main.async {
            if let msg = message["type"] as? String {
//                self.counterData.append(counterValue)
//                self.mainTableView.reloadData()
                if(msg == "AddMeal") {
                    name = "Snack"
                    photo = UIImage(named: "apple")
                    let date = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    let startTime = String(hour) + ":" + String(minutes)
                    let endTime = startTime
                    
                    let meal = Meal(name: name, photo: photo, startTime: startTime, endTime: endTime)
                    meals.append(meal!)
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                    for m in meals {
                        print(m)
                    }
                }else if(msg == "AddWater"){
                    name = "Water"
                    photo = UIImage(named: "water")
                    self.printMessagesForUser()
                }else{
                    let date = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    let startTime = String(hour) + ":" + String(minutes)
                    let endTime = startTime
                    
                    let meal = Meal(name: name, photo: photo, startTime: startTime, endTime: endTime)
                    meals.append(meal!)
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                    for m in meals {
                        print(m)
                    }
                }
                
            }
        }

    }
    
    // Backend Call
    func printMessagesForUser() -> Void {
//        let json = ["user":"sunny"]
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
//            let url = NSURL(string: "http://192.168.53.99:5000/api/get_messages")!
            let url = NSURL(string: "http://d03f4289.ngrok.io/api/get_messages")!
            let request = NSMutableURLRequest(url: url as URL)
//            request.httpMethod = "POST"
            request.httpMethod = "GET"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                }
                else {
                    
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(String(describing: result?["class"]))")
                    if (String(describing: result?["class"]) == "eating"){
                        let date = Date()
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: date)
                        let minutes = calendar.component(.minute, from: date)
                        let startTime = String(hour) + ":" + String(minutes)
                        let endTime = startTime
                        
                        let meal = Meal(name:"Snack", photo: UIImage(named: "apple"), startTime: startTime, endTime: endTime)
                        meals.append(meal!)
                        print("Eating item added to meals")
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                    }else{
                        let date = Date()
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: date)
                        let minutes = calendar.component(.minute, from: date)
                        let startTime = String(hour) + ":" + String(minutes)
                        let endTime = startTime
                        
                        let meal = Meal(name:"Meal", photo: UIImage(named: "lunch"), startTime: startTime, endTime: endTime)
                        meals.append(meal!)
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                    }
                    
                } catch {
                    print("Error -> \(error)")
                }
                }
            }
            
            task.resume()
//        } catch {
//            print(error)
//        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else{
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.startTimeLabel.text = meal.startTime
        cell.endTimeLabel.text = meal.endTime
        var color = "D3D3D3"
        if cellColors[meal.name] != nil {color = cellColors[meal.name]!}
        cell.contentView.backgroundColor = hexStringToUIColor(hex: color)

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Change cell background color.
//    var cellColors = ["EBCFC4","EBCFC4","EBCFC4","D3D3D3"]
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
////        cell.contentView.backgroundColor = UIColor(rgb: cellColors[indexPath.row % cellColors.count]);
//        cell.contentView.backgroundColor = hexStringToUIColor(hex: cellColors[indexPath.row % cellColors.count])
//    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            saveMeals()
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "lunch")
        let photo2 = UIImage(named: "apple")
        let photo3 = UIImage(named: "water")
        
        guard let meal1 = Meal(name: "Salad", photo: photo1, startTime: "12:30", endTime: "1:30") else {
            fatalError("Unable to instantiatiate meal1")
        }
        guard let meal2 = Meal(name: "Snack", photo: photo2, startTime: "3:30", endTime: "3:35") else {
            fatalError("Unable to instantiatiate meal2")
        }
        guard let meal3 = Meal(name: "Water", photo: photo3, startTime: "4:00", endTime: "4:01") else {
            fatalError("Unable to instantiatiate meal3")
        }
        
        meals += [meal1,meal2,meal3]
        
    }
    
    private func saveMeals(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }

}
