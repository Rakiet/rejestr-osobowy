//
//  PersonDataView.swift
//  rejestr-osobowy
//
//  Created by Piotr Żakieta on 25/09/2022.
//

import UIKit

protocol SaveNewPersonProtocol{
    func didSaveNewPerson(isSaved: Bool)
}

class PersonDataView: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthPickerView: UIDatePicker!
    @IBOutlet weak var sexSegmentedControle: UISegmentedControl!
    @IBOutlet weak var zipCodeFirstSegmentTextField: UITextField!
    @IBOutlet weak var zipCodeSecondSegmentTextField: UITextField!
    @IBOutlet weak var townTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var numberHouseTextField: UITextField!
    @IBOutlet weak var numberApartmentTextField: UITextField!
    
    var saveNewPersonDelegaye: SaveNewPersonProtocol!
    
    var personIsEdit = false
    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if personIsEdit{
            loadTextToEdit()
        }
    }
    
    func loadTextToEdit() {
        guard let person = person else { return }
        nameTextField.text = person.firstName
        lastNameTextField.text = person.lastName
        dateOfBirthPickerView.date = person.dateOfBirth!
        if person.sex {
            sexSegmentedControle.selectedSegmentIndex = 0
        } else {
            sexSegmentedControle.selectedSegmentIndex = 1
        }
        let zipString: NSString = person.zipCode! as NSString
        zipCodeFirstSegmentTextField.text = "\(zipString.substring(with: NSRange(location: 0, length: 2)))"
        zipCodeSecondSegmentTextField.text = "\(zipString.substring(with: NSRange(location: 3, length: 3)))"
        townTextField.text = person.town
        streetTextField.text = person.streetName
        numberHouseTextField.text = person.houseNumber
        numberApartmentTextField.text = person.apartmentNumber
    }
    

    @IBAction func savePersonData(_ sender: Any) {
        if checkValidForm(){
            let zipcode = "\(zipCodeFirstSegmentTextField.text!)-\(zipCodeSecondSegmentTextField.text!)"
            var sex: Bool {
                if sexSegmentedControle.selectedSegmentIndex == 0 {
                    return true
                } else {
                    return false
                }
            }
            
            if personIsEdit{
                
                DatabaseManagement.editData(data: person, firstName: nameTextField.text, lastName: lastNameTextField.text, town: townTextField.text, street: streetTextField.text, zipCode: zipcode, houseNumber: numberHouseTextField.text, apartmentNumber: numberApartmentTextField.text, sex: sex, dateOfBirth: dateOfBirthPickerView.date)
                self.saveNewPersonDelegaye.didSaveNewPerson(isSaved: true)
                self.navigationController?.popToRootViewController(animated: true)
                
            } else {
                
                do {
                    try DatabaseManagement.saveData(firstName: nameTextField.text, lastName: lastNameTextField.text, town: townTextField.text, street: streetTextField.text, zipCode: zipcode, houseNumber: numberHouseTextField.text, apartmentNumber: numberApartmentTextField.text, sex: sex, dateOfBirth: dateOfBirthPickerView.date)
                    self.saveNewPersonDelegaye.didSaveNewPerson(isSaved: true)
                    self.navigationController?.popToRootViewController(animated: true)
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        } else {
            print("valid is false")
        }
    }
    
    func checkValidForm() -> Bool{
        var isValid = true
        var validError = [String]()
        let redColor = UIColor.red.cgColor
        nameTextField.layer.borderWidth = 0
        lastNameTextField.layer.borderWidth = 0
        dateOfBirthPickerView.layer.borderWidth = 0
        sexSegmentedControle.layer.borderWidth = 0
        zipCodeFirstSegmentTextField.layer.borderWidth = 0
        zipCodeSecondSegmentTextField.layer.borderWidth = 0
        townTextField.layer.borderWidth = 0
        streetTextField.layer.borderWidth = 0
        numberHouseTextField.layer.borderWidth = 0

        
        if let name = nameTextField.text, nameTextField.text?.isEmpty == false {
            if name.isOnlyLetters{
                print("Imie prawidłowe")
            } else {
                validError.append("Imie musi składać się wyłącznie z liter")
                nameTextField.layer.borderColor = UIColor.red.cgColor
                nameTextField.layer.borderWidth = 1.0
                isValid = false
            }
        } else {
            validError.append("Pole imie nie może być puste")
            isValid = false
            nameTextField.layer.borderColor = UIColor.red.cgColor
            nameTextField.layer.borderWidth = 1.0
        }
        
        if let lastName = lastNameTextField.text, lastNameTextField.text?.isEmpty == false {
            if lastName.isOnlyLetters{
                print("Nazwisko prawidłowe")
            } else {
                validError.append("Nazwisko musi składać się wyłącznie z liter")
                lastNameTextField.layer.borderColor = UIColor.red.cgColor
                lastNameTextField.layer.borderWidth = 1.0
                isValid = false
            }
        } else {
            validError.append("Pole Nazwisko nie może być puste")
            lastNameTextField.layer.borderColor = UIColor.red.cgColor
            lastNameTextField.layer.borderWidth = 1.0
            isValid = false
        }
        
        if dateOfBirthPickerView.date < Calendar.current.date(byAdding: .year, value: -18, to: Date())! {
            print("Data prawidłowa")
        } else {
            validError.append("Musisz być pełnoletni aby móc zapisać się na listę")
            dateOfBirthPickerView.layer.borderColor = redColor
            dateOfBirthPickerView.layer.borderWidth = 1.0
            isValid = false
        }
        
        if sexSegmentedControle.selectedSegmentIndex >= 0 {
            print("Wybrano płeć")
        } else {
            validError.append("Proszę o wybranie płci.")
            sexSegmentedControle.layer.borderColor = redColor
            sexSegmentedControle.layer.borderWidth = 1.0
            isValid = false
        }
        
        if zipCodeFirstSegmentTextField.text?.isEmpty == false && zipCodeSecondSegmentTextField.text?.isEmpty == false {
            
            if zipCodeFirstSegmentTextField.text!.isOnlyNumbers && zipCodeSecondSegmentTextField.text!.isOnlyNumbers && zipCodeFirstSegmentTextField.text?.count == 2 && zipCodeSecondSegmentTextField.text?.count == 3 {
                print("Kod pocztowy ok")
            } else {
                zipCodeSecondSegmentTextField.layer.borderColor = redColor
                zipCodeSecondSegmentTextField.layer.borderWidth = 1.0
                zipCodeFirstSegmentTextField.layer.borderColor = redColor
                zipCodeFirstSegmentTextField.layer.borderWidth = 1.0
                isValid = false
                validError.append("Pole kodu pocztowego ma nieprawidłowy format, prawidłowy format: 00-000.")
            }
            
        } else {
            zipCodeSecondSegmentTextField.layer.borderColor = redColor
            zipCodeSecondSegmentTextField.layer.borderWidth = 1.0
            zipCodeFirstSegmentTextField.layer.borderColor = redColor
            zipCodeFirstSegmentTextField.layer.borderWidth = 1.0
            isValid = false
            validError.append("Pole kodu pocztowego nie mogą być pustę.")
        }
        
        if townTextField.text?.isEmpty == false {
                print("Miasto prawidłowa")
        } else {
            validError.append("Pole Miasto nie może być puste")
            isValid = false
            townTextField.layer.borderColor = UIColor.red.cgColor
            townTextField.layer.borderWidth = 1.0
        }
        
        if streetTextField.text?.isEmpty == false {
                print("Ulica prawidłowa")
        } else {
            validError.append("Pole Ulica nie może być puste")
            isValid = false
            streetTextField.layer.borderColor = UIColor.red.cgColor
            streetTextField.layer.borderWidth = 1.0
        }
        
        if numberHouseTextField.text?.isEmpty == false {
            print("numer domu prawidłowy")
        } else {
            validError.append("Pole Nr Domu nie może być puste")
            isValid = false
            numberHouseTextField.layer.borderColor = UIColor.red.cgColor
            numberHouseTextField.layer.borderWidth = 1.0
        }
        
        if validError.isEmpty == false {
            MessageAlert.showValidAlert(title: "Nieprawidłowo uzupełnione pola", messageTable: validError, vc: self)
        }
        
        return isValid
    }

}


