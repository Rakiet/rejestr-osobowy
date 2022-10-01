//
//  ViewController.swift
//  rejestr-osobowy
//
//  Created by Piotr Żakieta on 25/09/2022.
//

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All") {
        filtredPerson = personFromCoreData.filter
        {
            person in
            let scopeMatch = (scopeButton == "All" || person.firstName == scopeButton)
            if(searchController.searchBar.text != ""){
                let searchTextString = "\(person.firstName!) \(person.lastName!) \(person.town!) \(person.zipCode!) \(person.streetName!)"
                let searchTextMatch = searchTextString.lowercased().contains(searchText.lowercased())
                
                return scopeMatch && searchTextMatch
            } else {
                return scopeMatch
            }
        }
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var editRow = 0
    
    var personFromCoreData = [Person]()
    var filtredPerson = [Person]()
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadDataFromDataBase()
        initSearchController()
    }
    
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
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
        if(searchController.isActive){
            return filtredPerson.count
        }
        return personFromCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PersonViewCell
        var model: Person
        if (searchController.isActive)
        {
            model = filtredPerson[indexPath.row]
        } else {
            model = personFromCoreData[indexPath.row]
        }
        
        cell?.configureTaskCell(person: model)
        
        return cell!
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextDelete = UIContextualAction(style: .destructive, title: "Usuń") {  (contextualAction, view, boolValue) in
            if (self.searchController.isActive) {
                
                DatabaseManagement.deleteData(taskToDelete: self.filtredPerson[indexPath.row])
                self.filtredPerson.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
                
                self.taskDataBaseIsEmpty(reloadDataWhenTaskEntityIsNotEmpty: false)
                self.loadDataFromDataBase()
            } else {
                DatabaseManagement.deleteData(taskToDelete: self.personFromCoreData[indexPath.row])
                self.personFromCoreData.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
                
                self.taskDataBaseIsEmpty(reloadDataWhenTaskEntityIsNotEmpty: false)
            }
        }
        
        let contextEdit = UIContextualAction(style: .normal, title: "Edytuj") {  (contextualAction, view, boolValue) in
            self.editRow = indexPath.row
            self.performSegue(withIdentifier: "segueToEditPersonData", sender: nil)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextDelete, contextEdit])

        return swipeActions
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
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
           } else if (segue.identifier == "segueToEditPersonData") {
               let dvc = segue.destination as! PersonDataView
               dvc.saveNewPersonDelegaye = self
               dvc.personIsEdit = true
               if (searchController.isActive)
               {
                   dvc.person = filtredPerson[editRow]
               } else {
                   dvc.person = personFromCoreData[editRow]
               }
           }
       }
   }

