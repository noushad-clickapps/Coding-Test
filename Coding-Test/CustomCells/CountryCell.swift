//
//  CountryCell.swift
//  Coding-Test
//
//  Created by Noushad on 8/24/18.
//  Copyright © 2018 Noushad. All rights reserved.
//

import UIKit

protocol CountryCellDelegate {
    func rowDeletedFor(cell:CountryCell)
    func updateCountryViewModel(_ viewModel:CountryViewModel, forCell cell:CountryCell)
    func userStartsSwipingFor(cell:CountryCell)
    
}

class CountryCell: UITableViewCell {
    
    let deleteIconAnchorPoint = 100.0
    
    //frontView: Showing the text fetched from API
    @IBOutlet weak var frontView: UIView!
    
    //backView: Used for displaying the bomb icon and placing purple color as per the requirment
    @IBOutlet weak var backView: UIView!
    
    //Contraints IBOuletes for both leading and traling so that we can move the frontView as user moves his finger or tries to swipe
    @IBOutlet weak var frontViewTLC: NSLayoutConstraint!
    @IBOutlet weak var frontViewLC : NSLayoutConstraint!
    
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCountryCurrency: UILabel!
    @IBOutlet weak var lblCountryLanguage: UILabel!
    
    //required to determine the distance user swiped from right to left
    var panStartpoint:CGPoint?
    var currentPoint:CGPoint?
    var delta = 0.0
    
    var delegate:CountryCellDelegate?
    
    //Setting countriesViewModel property, gets called whenever this property assigned a value and set the text to CountryCell UILabel's
    var countriesViewModel : CountryViewModel! {
        didSet {
            lblCountryName.text = countriesViewModel.name
            lblCountryCurrency.text = "Currency: \(countriesViewModel.currency)"
            lblCountryLanguage.text = "Language: \(countriesViewModel.language)"
        }
    }
    
    //Adding pangesture so that we can show the puple view as user moves his finger to left of the screen
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.backgroundColor = UIColor.purple
        self.selectionStyle = .none
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureTriggered(_ :)))
        pangesture.delegate = self
        self.addGestureRecognizer(pangesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK:- panGestureTriggered
    //Detecting the distance user's finger travelled on the cell and with what speed, on basis of that showing and hiding the bomb icon and deleteing the cells
    @objc func panGestureTriggered(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case UIGestureRecognizerState.began:
            //self.panStartPoint = [recognizer translationInView:self.myContentView];
            panStartpoint = gesture.translation(in: self)
            self.delegate?.userStartsSwipingFor(cell: self)
            break
        case UIGestureRecognizerState.changed:
            currentPoint = gesture.translation(in: self)
            delta = Double((panStartpoint?.x)! - currentPoint!.x)
            if delta > 0 {
                frontViewTLC.constant = CGFloat(delta)
                frontViewLC.constant = CGFloat(-delta)
                UIView.animate(withDuration: 0.5, animations: {
                    self.layoutIfNeeded()
                })
            }
            break
            
        case UIGestureRecognizerState.ended:
            let swipeVelocity = gesture.velocity(in: self).x
            if delta > deleteIconAnchorPoint {
                if swipeVelocity < -500 {
                    // we have fast swipe delete entire row
                    print("delete row")
                    self.delegate?.rowDeletedFor(cell: self)
                } else {
                    //we passed anchor point and velocity is slow so only show the bomb icon
                    countriesViewModel.isBombIconVisible = true
                    self.delegate?.updateCountryViewModel(countriesViewModel, forCell: self)
                    setConstantForConstraints(value: CGFloat(deleteIconAnchorPoint), animated: true)
                    UIView.animate(withDuration: 0.5, animations: {
                        self.layoutIfNeeded()
                    })
                }
            } else {
                // we are beyond delta point
                if swipeVelocity > -500 {
                    //speed is slow so cancel the swipe action
                    countriesViewModel.isBombIconVisible = false
                    self.delegate?.updateCountryViewModel(countriesViewModel, forCell: self)
                    setConstantForConstraints(value: 0, animated: true)
                }
            }
            break
        case UIGestureRecognizerState.cancelled:
            break
        default:
            break
        }
    }
    
    //MARK:- gestureRecognizer
    // required so that our cell and UITableView recognize other gesture's too
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK:- setConstantForConstraints
    //setting the frontView leading and trailing constriant value with or without animation
    func setConstantForConstraints(value:CGFloat, animated:Bool) {
        frontViewTLC.constant = CGFloat(value)
        frontViewLC.constant = CGFloat(-value)
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
}


