import Foundation
import UIKit



enum FontType: String {
    case assistantRegular = "Assistant-Regular"
    case assistantMedium = "Assistant-Medium"
    case assistantBold = "Assistant-Bold"
    case assistantSemiBold = "Assistant-SemiBold"
}


enum FontSize {
    case custom(Double)
    case theme(FontStyle)
    
}



enum FontStyle {
    case h1
    case h2
    case h3
    case buttonTitle
    case secondaryText
    case caption
    
}


extension FontStyle {
    var size: Double {
        switch self {
        case .h1:
            return 32
        case .h2:
            return 26
        case .h3:
            return 22
        case .buttonTitle:
            return 16
        case .secondaryText:
            return 14
        case .caption:
            return 12
        }
    }
    
    private var fontDescription: FontDescription {
        switch self {
        case .h1:
            return FontDescription(font: .assistantBold, size: .theme(.h1), style: .title1)
        case .h2:
            return FontDescription(font: .assistantMedium, size: .theme(.h2), style: .title2)
        case .h3:
            return FontDescription(font: .assistantMedium, size: .theme(.h3), style: .title3)
        case .buttonTitle:
            return FontDescription(font: .assistantRegular, size: .theme(.buttonTitle), style: .body)
        case .secondaryText:
            return FontDescription(font: .assistantRegular, size: .theme(.secondaryText), style: .body)
        case .caption:
            return FontDescription(font: .assistantMedium, size: .theme(.caption ), style: .caption1)
        }
    }
    
    var font: UIFont {
        guard let font = UIFont(name: fontDescription.font.name, size: fontDescription.size.value) else {
            return UIFont.preferredFont(forTextStyle: fontDescription.style)
        }
        let fontMetrics = UIFontMetrics(forTextStyle: fontDescription.style)
        return fontMetrics.scaledFont(for: font)
    }
}


extension FontType {
    var name: String {
        return self.rawValue
    }
}




extension FontSize {
    var value: Double {
        switch self {
        case .custom(let customSize):
            return customSize
        case .theme(let size):
            return size.size
        }
    }
}

extension UIFont {
    convenience init(type: FontType, size: FontSize) {
        self.init(name: type.name, size: size.value)!
    }
    
    static func style(_ style: FontStyle) -> UIFont {
        return style.font
    }
}

private struct FontDescription {
    let font: FontType
    let size: FontSize
    let style: UIFont.TextStyle
    
    
}

