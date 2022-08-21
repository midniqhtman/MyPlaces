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
    
    var rating = 0
    
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
        print("button is pressed")
    }

    //MARK: Private methods
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        for _ in 1...starCount {
        //create button
        let button = UIButton()
        button.backgroundColor = .blue
        
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
    }
}
