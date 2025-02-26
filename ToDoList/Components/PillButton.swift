//
//  PillButton.swift
//  ToDoList
//
//  Created by Станислав Витальевич on 27.02.2025.
//

import UIKit

class PillButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // работает также как и ViewDidLoad
        titleLabel?.backgroundColor = .link
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // кнопка в форме таблетки
        layer.cornerRadius = frame.height / 2
    }

}
