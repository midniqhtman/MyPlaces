//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Байсаев Зубайр on 22.08.2022.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    //MARK: Properties
    
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        //calculate rating of selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }

    //MARK: Private methods
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        //load button image
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
       
        let highlitedStar = UIImage(named: "highlitedStar",
                                    in: bundle,
                                    compatibleWith: self.traitCollection)
        
        for _ in 1...starCount {
        //create button
        let button = UIButton()

        //set the button image
        button.setImage(emptyStar, for: .normal)
        button.setImage(filledStar, for: .selected)
        button.setImage(highlitedStar, for: .highlighted)
            button.setImage(highlitedStar, for: [.highlighted, .selected])



            
        //add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        
        //setup button actions
        button.addTarget(self, action: #selector(ratingButtonTapped(button: )), for: .touchUpInside)
        
        //add to the stackview
        addArrangedSubview(button)
            
            //add the newbutton in the rating
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
