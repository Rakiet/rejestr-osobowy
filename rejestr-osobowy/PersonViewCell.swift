//
//  PersonViewCell.swift
//  rejestr-osobowy
//
//  Created by Piotr Żakieta on 30/09/2022.
//

import UIKit

class PersonViewCell: UITableViewCell {
    
    
    @IBOutlet weak var personText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureTaskCell(person: Person?){
        var sexName = ""
        let dateNow = Date()
        guard let firstName = person?.firstName,
              let lastName = person?.lastName,
              let streetName = person?.streetName,
              let houseNumber = person?.houseNumber,
              var apartmentNumber = person?.apartmentNumber,
              let zipCode = person?.zipCode,
              let town = person?.town,
              let date = person?.dateOfBirth,
              let sex = person?.sex else { return }
        
        if apartmentNumber != "" {
            apartmentNumber = "/\(apartmentNumber)"
        }
        
        let yearOld = dateNow.get( .year) - date.get( .year) // rok rocznikowo
        
        if sex == true {
            sexName = "Mężczyzna"
        } else {
            sexName = "Kobieta"
        }
        
        personText.text = "\(firstName) \(lastName)\n\(sexName) Lat: \(yearOld)\nul. \(streetName) \(houseNumber) \(apartmentNumber)\n\(zipCode) \(town)"
    }
    
//    func setDateTextField(dateTask: Date){
//        if Calendar.current.isDate(dateTask, inSameDayAs: Date.now){
//            dateTextLabel.textColor = UIColor.systemBlue
//        } else if dateTask < Date.now{
//            dateTextLabel.textColor = UIColor.red
//        } else if dateTask > Date.now{
//            dateTextLabel.textColor = UIColor.systemGreen
//        }
//    }
    
    func setStringFromDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
