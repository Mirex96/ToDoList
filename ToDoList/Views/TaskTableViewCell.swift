import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func editTask(id: String)
    func markTask(id: String, complete: Bool)
}
 
class TaskTableViewCell: UITableViewCell {

    static let identifier = "TaskTableViewCell"
    
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var isCompletemageView: UIImageView!
    private weak var delegate: TaskTableViewCellDelegate?
    
    @IBOutlet weak var stripView: UIView!
    
    
    
    private var task: Task!
    
    // вычисляемое свойство для Даты
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryContainerView.layer.cornerRadius = 13
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
    }
    
    func configure(withTask task: Task, delegate: TaskTableViewCellDelegate?) {
        
        //настройка цвета:
        stripView.backgroundColor = task.category.color
        categoryContainerView.backgroundColor = task.category.secondaryColor
        categoryLabel.textColor = task.category.color
        
        categoryLabel.text = task.category.rawValue
        captionLabel.text = task.caption
        
        // если задание не выполнено будет просто кружок, если выполнено кружок с галочкой
        isCompletemageView.image = task.isComplete ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        
        // настраиваем дату
        dataLabel.text = dateFormatter.string(from: task.createdDate)
        
        // делаем, чтобы при выборе задачи она не отображалась серым цветом
        selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleCompletion))
        isCompletemageView.addGestureRecognizer(tap)
        isCompletemageView.isUserInteractionEnabled = true
        self.task = task
        self.delegate = delegate
     

    }
    
    @objc func toggleCompletion() {
        task.isComplete.toggle()
        delegate?.markTask(id: task.id, complete: task.isComplete)
    }

    @IBAction func editTaskButtonTapped(_ sender: UIButton) {
        delegate?.editTask(id: task.id)
    }
     
}

