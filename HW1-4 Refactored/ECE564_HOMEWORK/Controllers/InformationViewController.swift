//
//  InformationViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/3/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

// protocol used to pass data back to tableViewController
protocol PassDataBack {
    func dataReceived(personEdited: DukePerson)
}

class InformationViewController: UIViewController {
    
    var person = DukePerson()
    var delegate: PassDataBack? // will be assigned to the tableVC, who will also receive data from here
    var errorOccurred: Bool = false
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var languagesTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    
    @IBOutlet weak var genderSC: UISegmentedControl!
    @IBOutlet weak var roleSC: UISegmentedControl!
    @IBOutlet weak var degreeSC: UISegmentedControl!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var flipButton: UIButton!
    @IBAction func flipButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "FlipSegue", sender: self.flipButton)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPersonalInformation()
        self.isEditing = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Flip button is only available to myself
        if firstNameTextField.text != "Yifan" && lastNameTextField.text != "Li" {
            flipButton.isHidden = true
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Toggles the edit button state
        super.setEditing(editing, animated: animated)
        
        if editing {
            // edit mode
            toggleUserInteraction(enabled: true)
            self.firstNameTextField.textColor = UIColor.gray
            self.lastNameTextField.textColor = UIColor.gray
            let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.saveButtonPressed(sender:)))
            self.navigationItem.rightBarButtonItem = saveButton
        } else {
            // preview mode
            toggleUserInteraction(enabled: false)
        }
        
    }
    
    @objc func saveButtonPressed(sender: UIBarButtonItem) {
        errorOccurred = getPersonalInformation()
        if errorOccurred == false {
            delegate?.dataReceived(personEdited: self.person)
            navigationController?.popViewController(animated: true)
        } else {
            return
        }
        
    }
    
    // Display a person's detailed information
    func loadPersonalInformation() {
        self.firstNameTextField.text = person.firstName
        self.lastNameTextField.text = person.lastName
        self.fromTextField.text = person.whereFrom
        self.hobbiesTextField.text = person.hobbies.joined(separator: ", ")
        self.languagesTextField.text = person.bestProgrammingLanguage.joined(separator: ", ")
        self.avatarImageView.image = (person.gender == .Male) ? UIImage(named: "male.png") : UIImage(named: "female.png")
        self.genderSC.selectedSegmentIndex = (person.gender == .Male) ? 0 : 1
        
        switch person.role {
        case .Professor:
            self.roleSC.selectedSegmentIndex = 1
            self.teamTextField.isEnabled = false
        case .TA:
            self.roleSC.selectedSegmentIndex = 2
            self.teamTextField.isEnabled = false
        case .Student:
            self.roleSC.selectedSegmentIndex = 0
            self.teamTextField.isEnabled = true
            self.teamTextField.text = person.team
        }
        
        switch person.degree {
        case "MS":
            self.degreeSC.selectedSegmentIndex = 0
        case "BS":
            self.degreeSC.selectedSegmentIndex = 1
        case "MENG":
            self.degreeSC.selectedSegmentIndex = 2
        case "PhD":
            self.degreeSC.selectedSegmentIndex = 3
        case "NA":
            self.degreeSC.selectedSegmentIndex = 4
        default:
            self.degreeSC.selectedSegmentIndex = 5
        }
    }
    
    func toggleUserInteraction(enabled: Bool) {
        self.firstNameTextField.isUserInteractionEnabled = false
        self.lastNameTextField.isUserInteractionEnabled = false
        self.fromTextField.isUserInteractionEnabled = enabled
        self.hobbiesTextField.isUserInteractionEnabled = enabled
        self.languagesTextField.isUserInteractionEnabled = enabled
        self.teamTextField.isUserInteractionEnabled = enabled
        self.genderSC.isUserInteractionEnabled = enabled
        self.roleSC.isUserInteractionEnabled = enabled
        self.degreeSC.isUserInteractionEnabled = enabled
    }
    
    // Get and check all inputs. Return true if there is an error
    func getPersonalInformation() -> Bool {
        if  (self.fromTextField.text?.isEmpty)! ||   (self.hobbiesTextField.text?.isEmpty)! || (self.languagesTextField.text?.isEmpty)! || ((self.roleSC.selectedSegmentIndex == 0) && (self.teamTextField.text?.isEmpty)!) {
            displayAlertMessage(title: "ERROR!", message: "All fields are required!")
            return true
        }
    
        self.person.whereFrom = self.fromTextField.text!
        self.person.fullName = self.person.firstName + " " + self.person.lastName
        self.person.gender = (self.genderSC.selectedSegmentIndex == 0) ? .Male : .Female
        
        switch self.roleSC.selectedSegmentIndex {
        case 1:
            self.person.role = .Professor
        case 2:
            self.person.role = .TA
        default:
            self.person.role = .Student
        }
        
        switch self.degreeSC.selectedSegmentIndex {
        case 0:
            self.person.degree = "MS"
        case 1:
            self.person.degree = "BS"
        case 2:
            self.person.degree = "MENG"
        case 3:
            self.person.degree = "PhD"
        case 4:
            self.person.degree = "NA"
        default:
            self.person.degree = "other"
        }
        
        let hobbies: [String] = hobbiesTextField.text!.components(separatedBy: ",").filter({$0 != ""})
        if hobbies.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 hobbies!")
            return true
        }
        self.person.hobbies = hobbies
        
        let languages: [String] = languagesTextField.text!.components(separatedBy: ",").filter({$0 != ""})
        if languages.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 languages!")
            return true
        }
        self.person.bestProgrammingLanguage = languages
        
        // until this point, all inputs are valid, no error occurred.
        return false
    }

    // Pop-up alert to display the error message
    func displayAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func returnFromDrawingView(segue: UIStoryboardSegue) {
    
    }
    
    //MARK: HW4
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let segue = UnwindFlipSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    
}
