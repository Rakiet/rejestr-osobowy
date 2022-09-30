//
//  ViewController.swift
//  rejestr-osobowy
//
//  Created by Piotr Żakieta on 25/09/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var personFromCoreData = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        loadDataFromDataBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func loadDataFromDataBase(){
        do{
            personFromCoreData = try DatabaseManagement.readBase()
        } catch {
            print(error.localizedDescription)
        }
        
        taskDataBaseIsEmpty(reloadDataWhenTaskEntityIsNotEmpty: true)
    }
    
    func taskDataBaseIsEmpty(reloadDataWhenTaskEntityIsNotEmpty reload:Bool){
        if !personFromCoreData.isEmpty{
            if reload{
                tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personFromCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PersonViewCell
        let model = personFromCoreData[indexPath.row]
        cell?.configureTaskCell(person: model)
        
        return cell!
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            DatabaseManagement.deleteData(taskToDelete: self.personFromCoreData[indexPath.row])
            self.personFromCoreData.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            
            self.taskDataBaseIsEmpty(reloadDataWhenTaskEntityIsNotEmpty: false)
            
        }
    }
    
}

   extension ViewController: SaveNewPersonProtocol {
       func didSaveNewPerson(isSaved: Bool) {
           if isSaved{
               loadDataFromDataBase()

           }else{
               taskDataBaseIsEmpty(reloadDataWhenTaskEntityIsNotEmpty: false)
           }
       }


   }

   extension ViewController {
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if (segue.identifier == "segueToPersonData"){
               let dvc = segue.destination as! PersonDataView
               dvc.saveNewPersonDelegaye = self
           }
       }
   }

