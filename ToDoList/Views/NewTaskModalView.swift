import UIKit
import os

class NewTaskModalView: UIView {
    @IBOutlet private weak var descriptionTectView: UITextView!
    @IBOutlet private weak var categoryPickerView: UIPickerView!
    @IBOutlet private var contentView: UIView!
    weak var delegate: NewTaskDelegate?
    private var task: Task?
    
    var caption: String {
        get { return descriptionTectView.text }
        set { descriptionTectView.text = newValue }
    }
    
    init(frame: CGRect, task: Task?) {
        super.init(frame: frame)
        self.task = task
        initSubviews()
    }
    
    // метод кодирования отвечает за инициализацию визуальных объектов
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    // метод отвечает за инициализацию всех объектов
    func initSubviews() {
        let nib = UINib(nibName: "NewTaskModalView", bundle: nil)
        nib.instantiate(withOwner: self)
        
        // Настройка представления для ввода текста
        descriptionTectView.layer.borderWidth = 0.5
        descriptionTectView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTectView.layer.cornerRadius = 8
        descriptionTectView.delegate = self
        // Настройка представления с выбором категорий
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        // Настройки для редактирования созданной задачи
        if let task = task {
            // если задачи не было, то оставляем возможность ее создать
            descriptionTectView.text = task.caption
            descriptionTectView.textColor = UIColor.label
            if let rowIndex = Category.allCases.firstIndex(of: task.category) {
                categoryPickerView.selectRow(rowIndex, inComponent: 0, animated: false)
            }
        } else {
            // если задача существует, даем возможность ее изменить
            descriptionTectView.text = "Add caption..."
            descriptionTectView.textColor = .placeholderText  // текст на две темы динамический
            categoryPickerView.selectRow(1, inComponent: 0, animated: false)
        }
        
        contentView.frame = bounds // чтобы рамка объекта занимала весь View
        addSubview(contentView)
        
    }
    
    override func layoutSubviews() {
        // закругление углов самого Таблета
        contentView.layer.cornerRadius = 5
    }
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        delegate?.closeView()
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        os_log("Task creation has started. Submit button tapped / Началось создание задания. Нажата кнопка Отправить", type: .info)
        
        guard let caption = descriptionTectView.text,
              descriptionTectView.textColor != UIColor.placeholderText,
              caption.count >= 4 && caption.count <= 50 else { 
            delegate?.presentErrorAlert(title: "Caption Error", message: "You need to provide a description with 4 or more charaters")
            shakeAnimation()
            return
        }
        os_log("Validation of task suceeded / Проверка выполнения задачи выполнена успешно", type: .info)
        
        let selectedRow = categoryPickerView.selectedRow(inComponent: 0)
        let category = Category.allCases[selectedRow]
        if let task = task {
            let task = Task(id: task.id, category: category, caption: caption, createdDate: task.createdDate, isComplete: task.isComplete)
            let userInfo: [String: Task] = ["updateTask": task]
            NotificationCenter.default.post(name: NSNotification.Name("com.Mirex96.editTask"), object: nil, userInfo: userInfo)
        } else {
            // cоздаем объект задачи
            let taskId = UUID().uuidString
            let task = Task(id: taskId, category: category, caption: caption, createdDate: Date(), isComplete: false)
            // объект с информацией о пользователе
            let userInfo: [String: Task] = ["newTask": task]
            os_log("Task posted as part of notification / Задача, опубликованная как часть уведомления", type: .info)
            // центр уведомлений
            NotificationCenter.default.post(name: NSNotification.Name("com.Mirex96.createTask"), object: nil, userInfo: userInfo)
        }
        // после добавления задачи закрываем окно
        delegate?.closeView()
    }
    
}

// делегат позволяющий узнать ввел ли пользователь текст в текстовое поле
extension NewTaskModalView: UITextViewDelegate {
    
    // метод который позволяет узнать когда пользователь начинает редактировать текст
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {  // placeholderText - динамический текст на две темы
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    // метод проверяет пуст ли текст и текстовое поле
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add caption..."
            textView.textColor = UIColor.placeholderText
        }
    }
}

// Методы для настройки категорий (пикера)
extension NewTaskModalView: UIPickerViewDataSource {
    
    // метод добавления количества компонентов
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Метод количества категорий в компоненте (категории добавили из enum)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
}

// убеждаемся что отображается правильное значение строки в Категории
extension NewTaskModalView: UIPickerViewDelegate {
    
    // Правильный метод заполнения для строки категирий
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            pickerLabel?.textAlignment = .center
        }
        let category = Category.allCases[row]
        pickerLabel?.text = category.rawValue
        return pickerLabel!
    }
}

extension UIView {
    func shakeAnimation(duration: TimeInterval = 0.5, shakeCount: Float = 3, translationX: CGFloat = 5) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.duration = duration / TimeInterval(shakeCount)
        animation.repeatCount = shakeCount
        animation.autoreverses = true
        animation.fromValue = self.center.x - translationX
        animation.toValue = self.center.x + translationX
        self.layer.add(animation, forKey: "position.x")
    }
}



