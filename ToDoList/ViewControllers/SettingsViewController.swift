

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var appThemeLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTitleLabel.font = UIFont.style(.h1)
        //  appThemeLabel.font = UIFont.style(.formLabel)
        let window = UIApplication.shared.connectedScenes.flatMap{ ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        if let window = window {
            switch window.overrideUserInterfaceStyle {
            case .unspecified:
                segmentedControl.selectedSegmentIndex = 2
            case .light:
                segmentedControl.selectedSegmentIndex = 0
            case .dark:
                segmentedControl.selectedSegmentIndex = 1
            @unknown default:
                segmentedControl.selectedSegmentIndex = 2
            }
            
        }
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        modalView.layer.cornerRadius = 5
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
  
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // доступ к объекту приложения
        let window = UIApplication.shared.connectedScenes.flatMap{ ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        
        // если выбранный сегмент = 0 тоесть первый мы включаем светлый режим
        if sender.selectedSegmentIndex == 0 {
            window?.overrideUserInterfaceStyle = .light
            // темный режим
        } else if sender.selectedSegmentIndex == 1 {
            window?.overrideUserInterfaceStyle = .dark
            // устанавливаются системные настройки
        } else {
            window?.overrideUserInterfaceStyle = .unspecified
        }
        
        
            
        
        
        
    }
    
}

