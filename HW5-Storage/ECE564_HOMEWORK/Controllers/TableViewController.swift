//
//  TableViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/3/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, PassDataBack {

    var people = [DukePerson]()
    var peopleArray: [[DukePerson]] = [[], [], []]//for easier alignment with tableViewCell indices
    var teams: [(teamName: String, sectionID: Int)] = []
    var studentsWithNoTeams: [DukePerson] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return peopleArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peopleArray[section].count + 1 // row 0 will be separator cells, so add 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorCell", for: indexPath) as! SeparatorCell
            
            if indexPath.section == 0 {
                cell.roleLabel.text = "Professor"
            } else if indexPath.section == 1 {
                cell.roleLabel.text = "TA"
            } else {
                for team in self.teams {
                    if team.sectionID == indexPath.section {
                        if peopleArray[indexPath.section].isEmpty {
                            cell.isHidden = true
                        }
                        cell.roleLabel.text = "Team " + team.teamName
                        break
                    }
                }
            }

            return cell
        } else { // display a personCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
            let nextPerson: DukePerson = peopleArray[indexPath.section][indexPath.row-1]
            cell.thisPerson = nextPerson
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if peopleArray[indexPath.section].isEmpty && indexPath.row == 0 {
            return CGFloat(0.0)
        } else if !peopleArray[indexPath.section].isEmpty && indexPath.row == 0 { // separator cell
            return CGFloat(44.0)
        } else { // person cell
            return CGFloat(125.0)
        }
    }
    
    var personClicked: DukePerson?
    var personCellClicked: Bool = false
    // Whenever a personCell is clicked, redirect to informationView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        // Separator cells' row index are 0s, [indexPath.row-1] out of range
        if indexPath.row > 0 {
            personClicked = peopleArray[indexPath.section][indexPath.row-1]
            personCellClicked = true
            performSegue(withIdentifier: "showInformation", sender: nil)
        }
    }
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    // When anything except a personCell is clicked, do not perform segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return (personCellClicked == true) || (sender as? UIBarButtonItem == addButton) ? true : false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInformation" {
            let informationVC = segue.destination as! InformationViewController
            informationVC.person = personClicked!
            informationVC.delegate = self // set self as the delegate that will receive data passing back
        } else if segue.identifier == "addNewPerson" {
            let navVC = segue.destination as! UINavigationController
            let newPersonVC = navVC.viewControllers.first as! AddViewController
            newPersonVC.people = self.people
        }
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
    
    // Pre-populate the table with hardcoded data
    func loadInitialData() {
        let myself: DukePerson = DukePerson(firstName: "Yifan", lastName: "Li", whereFrom: "Hebei, China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["C", "C++", "Python"], hobbies: ["Playing soccer", "Playing online games", "Cardio workout"], role: .Student, team: "MoveIt")
        let professor: DukePerson = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC", gender: .Male, degree: "NA", bestProgrammingLanguage: ["Swift", "C", "C++"], hobbies: ["Golf", "Swimming", "Biking"], role: .Professor, team: "")
        let ta1: DukePerson = DukePerson(firstName: "Walker", lastName: "Eacho", whereFrom: "Chevy Chase, MD", gender: .Male, degree: "BS", bestProgrammingLanguage: ["Swift", "Objective-C", "C"], hobbies: ["Sailing", "Climbing", "Baking"], role: .TA, team: "")
        let ta2: DukePerson = DukePerson(firstName: "Niral", lastName: "Shah", whereFrom: "Central New Jersey", gender: .Male, degree: "MENG", bestProgrammingLanguage: ["Swift", "Python", "C"], hobbies: ["Computer Vision projects", "Tennis", "Traveling"], role: .TA, team: "")
        let teammate1: DukePerson = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["C", "C++", "Java"], hobbies: ["Running", "Swimming"], role: .Student, team: "MoveIt")
        
        self.people.append(professor)
        self.people.append(ta1)
        self.people.append(ta2)
        self.people.append(myself)
        self.people.append(teammate1)
        
        for person in self.people {
            if person.role == .Professor {
                peopleArray[0].append(person)
            } else if person.role == .TA {
                peopleArray[1].append(person)
            } else {
                peopleArray[2].append(person)
            }
        }
        
        //TODO: Link team and separator cell
        self.teams.append((teamName: "MoveIt", sectionID: 2))
        //
        
    }
    
    // Add a new person to the class if all information is valid
    
    @IBAction func returnFromNewPerson(segue: UIStoryboardSegue) {
        let source: AddViewController = segue.source as! AddViewController
        let newPerson: DukePerson = source.newPerson
        let errorOccurred: Bool = source.errorOccurred
        let cancelPressed: Bool = source.cancelPressed
        if (errorOccurred == false) && (cancelPressed == false) {
            self.people.append(newPerson)

            if newPerson.role == .Professor {
                peopleArray[0].append(newPerson)
            } else if newPerson.role == .TA {
                peopleArray[1].append(newPerson)
            } else if newPerson.role == .Student && newPerson.team == "" {
                studentsWithNoTeams.append(newPerson)
            } else {
                for team in self.teams {
                    if newPerson.team == team.teamName { // new member for an existing team
                        peopleArray[team.sectionID].append(newPerson)
                        // self.teams = sortByTeams()
                        if !studentsWithNoTeams.isEmpty {
                            self.peopleArray.append(studentsWithNoTeams)
                        }
                        self.tableView.reloadData()
                        return
                    }
                }
                // new team, team section index = teams.count
                let newTeam = (teamName: newPerson.team, sectionID: self.teams.count + 2) // eg: teams.count = 1, teams[1] -> tableView Section 3
                self.teams.append(newTeam)
                self.peopleArray.append([])
                self.peopleArray[newTeam.sectionID].append(newPerson)
            }
            // self.teams = sortByTeams()
            if !studentsWithNoTeams.isEmpty {
                self.peopleArray.append(studentsWithNoTeams)
            }
            self.tableView.reloadData()
        }
        
    }
    
//    func sortByTeams() -> [(String, Int)] {
//        var sortedTeams = self.teams.sorted(by: {$0.0 < $1.0})
//        for i in 0..<sortedTeams.count {
//            sortedTeams[i].sectionID = 2 + i
//        }
//        return sortedTeams
//    }
    
    
    
    // protocol method for receiving data
    func dataReceived(personEdited: DukePerson) {
        for i in 0..<self.peopleArray.count {
            for j in 0..<self.peopleArray[i].count {
                if peopleArray[i][j].fullName == personEdited.fullName {
                    peopleArray[i].remove(at: j)
                    break
                }
            }
        }
        
        if personEdited.role == .Professor {
            self.peopleArray[0].append(personEdited)
        } else if personEdited.role == .TA {
            self.peopleArray[1].append(personEdited)
        } else if personEdited.role == .Student && personEdited.team == "" {
            studentsWithNoTeams.append(personEdited)
        } else {
            for team in self.teams {
                if personEdited.team == team.teamName { // new member for an existing team
                    peopleArray[team.sectionID].append(personEdited)
                    if !studentsWithNoTeams.isEmpty {
                        self.peopleArray.append(studentsWithNoTeams)
                    }
                    self.tableView.reloadData()
                    return
                }
            }
            // new team
            let newTeam = (teamName: personEdited.team, sectionID: self.teams.count + 2) // eg: teams.count = 1, teams[1] -> tableView Section 3
            self.teams.append(newTeam)
            self.peopleArray.append([])
            self.peopleArray[newTeam.sectionID].append(personEdited)
        }
        if !studentsWithNoTeams.isEmpty {
            self.peopleArray.append(studentsWithNoTeams)
        }
        self.tableView.reloadData()
    }
    
    
    
}