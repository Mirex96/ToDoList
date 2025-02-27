
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    // массив для наших задач
    var tasks: [Task] = []
    
    
    // создаем кнопку добавления (+ снизу)
    // lazy означает что кнопка будет создана только один раз и только когда она понадобится
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)  // изменили размер плюса (больше в 1.4 раза)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside) // добавили нажатие для кнопки
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 24
        
        // чтобы закругления были снизу (левый низ, правый низ)
        titleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        tableView.dataSource = self
        
        // задаем приблизительную высоту строки в таблице
        tableView.estimatedRowHeight =  80
        // делаем так чтобы размер определялся автоматически
        tableView.rowHeight = UITableView.automaticDimension
        
        // добавление кнопки (добавить +) на экран
        view.addSubview(addButton)
        
        // добавляем центр уведомлений
        NotificationCenter.default.addObserver(self, selector: #selector(createTask(_ :)), name: NSNotification.Name("com.fullstacktuts.createTask"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(editTask(_ :)), name: NSNotification.Name("com.fullstacktuts.editTask"), object: nil)
        
        // убираем подчеркивание между задачами
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        
    }
    
    // функция которая будет вызываться при получении уведомления о новой задаче
    @objc func createTask(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let task = userInfo["newTask"] as? Task  else {
            return
        }
        tasks.append(task)
        tableView.reloadData()
    }
    
    @objc func editTask(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let taskToUpdate = userInfo["updateTask"] as? Task  else {
            return
        }
        let taskIndex = tasks.firstIndex { task in
            task.id == taskToUpdate.id
        }
        guard let taskIndex = taskIndex else {
            return
        }
        tasks[taskIndex] = taskToUpdate
        tableView.reloadData()
    }
    
    
    // установка рамок и раcположения для кнопки
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let safeAreaBottom = view.safeAreaInsets.bottom
        let width: CGFloat = 60
        let height: CGFloat = 60
        let xPos = view.frame.width / 2 - width / 2
        let yPos = view.frame.height - height - safeAreaBottom
        addButton.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        addButton.layer.cornerRadius = width / 2
    }
    
    // метод который будет вызываться при нажатии на кнопку (Добавить +)
    @objc func addButtonTapped() {
        let newTaskViewController = NewTaskViewController()
        present(newTaskViewController, animated: true)
    }
    
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "SettingsSegue", sender: nil)
        
    }
    
}

// реализация ячеек в TableView
extension ViewController: UITableViewDataSource {
    // количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // создаем экземпляр для отображения ячейки в UI
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        cell.configure(withTask: task, delegate: self)
        return cell
    }
    
    // удаление задачи
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension ViewController: TaskTableViewCellDelegate {
    func editTask(id: String) {
        let task = tasks.first { task in
            task.id == id
        }
        guard let task = task  else {
            return
        }
       
        let newTaskViewController = NewTaskViewController(task: task)
        present(newTaskViewController, animated: true)
    }
    
    
    func markTask(id: String, complete: Bool) {
        let taskIndex = tasks.firstIndex { task in
            task.id == id
        }
        guard let taskIndex = taskIndex else {
            return
        }
        tasks[taskIndex].isComplete = complete
        tableView.reloadData()
        
    }
    
    
    
    
}




