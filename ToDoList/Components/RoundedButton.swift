//
//  RoundedButton.swift
//  ToDoList
//
//  Created by Станислав Витальевич on 26.02.2025.
//

import UIKit

class RoundedButton: UIButton {
    
    
    // работает также как и ViewDidLoad
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.backgroundColor = .link
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // закругление для кнопки
        layer.cornerRadius = 5
    }
    
}

