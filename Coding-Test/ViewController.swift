//
//  ViewController.swift
//  Coding-Test
//
//  Created by Noushad on 8/24/18.
//  Copyright © 2018 Noushad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CountryCellDelegate {
    
    @IBOutlet weak var tblCountriesList : UITableView!
    
    var countryViewModel = [CountryViewModel]()
    var currentEditingRowIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupIntialSettings()
        getRecords()
    }
    
    //MARK:- setupIntialSettings
    // Set up intial setting for the viewcontroller
    fileprivate func setupIntialSettings() {
        tblCountriesList.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "countrycell")
        tblCountriesList.tableFooterView = UIView(frame: .zero)
        tblCountriesList.dataSource = self
        tblCountriesList.delegate = self
    }
    
    //MARK:- getRecords
    // Get records from the API
    fileprivate func getRecords() {
        Service.shared.getCountriesFromAPI { (countries, error) in
            if let error = error {
                print("Error fetching records == \(error.localizedDescription)")
                return
            }
            
            self.countryViewModel = countries?.map({ return CountryViewModel(country: $0)}) ?? []
            self.tblCountriesList.reloadData()
        }
        
    }
    
    //MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"countrycell") as! CountryCell
        cell.countriesViewModel = countryViewModel[indexPath.row]
        cell.setConstantForConstraints(value: 0, animated: false)
        if countryViewModel[indexPath.row].isBombIconVisible {
            cell.setConstantForConstraints(value: CGFloat(cell.deleteIconAnchorPoint), animated: false)
        }
        cell.delegate = self
        return cell
    }
    
    
    //MARK:- UItableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        checkIfUserStartInteractingWithOtherRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
    //MARK:- checkIfUserStartInteractingWithOtherRowAt
    //check that wether we have any row present with bomb icon and if user interacts with the other row then reset the privous row
    func checkIfUserStartInteractingWithOtherRowAt(indexPath:IndexPath) {
        guard let currentEditingRowindexPath = currentEditingRowIndex else {
            return
        }
        if currentEditingRowindexPath.row != indexPath.row {
            let viewModel = countryViewModel[currentEditingRowindexPath.row]
            viewModel.isBombIconVisible = false
            tblCountriesList.reloadRows(at: [currentEditingRowindexPath], with: .automatic)
        }
    }
    
    
    //MARK:- CountryCellDelegate
    
    //Delete the row as user swipes fast past anchor point
    func rowDeletedFor(cell:CountryCell) {
        guard let indexPath = returnIndexPathFor(cell: cell) else {
            return
        }
        countryViewModel.remove(at: indexPath.row)
        tblCountriesList.deleteRows(at: [indexPath], with: .left)
    }
    
    //update country view model so that we can keep track which record is showing bomb icon
    func updateCountryViewModel(_ viewModel:CountryViewModel, forCell cell:CountryCell) {
        guard let indexPath = returnIndexPathFor(cell: cell) else {
            return
        }
        countryViewModel[indexPath.row] = viewModel
    }
    
    //Getting current row indexpath with which user is interacting
    func userStartsSwipingFor(cell:CountryCell){
        guard let indexPath = returnIndexPathFor(cell: cell) else {
            return
        }
        checkIfUserStartInteractingWithOtherRowAt(indexPath: indexPath)
        currentEditingRowIndex = indexPath
    }
    
    
    //MARK:- returnIndexPathFor
    // return index path depending upon the cell
    func returnIndexPathFor(cell:CountryCell) -> IndexPath? {
        let touchPOint = cell.convert(CGPoint.zero, to: tblCountriesList)
        return tblCountriesList.indexPathForRow(at: touchPOint)
    }
    
    
    
    //MARK:- didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

