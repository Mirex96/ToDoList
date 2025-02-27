

import Foundation
import UIKit


enum Category: String, CaseIterable {
    case work = "Work", study = "Study", excersice = "Excersice"
    
    var color: UIColor {
        switch self {
        case .work:
            return UIColor.work
        case .study:
            return UIColor.study
        case .excersice:
            return UIColor.excercise
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .work:
            return UIColor.secondaryWork
        case .study:
            return UIColor.secondaryStudy
        case .excersice:
            return UIColor.secondaryExcercise
        }
    }
}

