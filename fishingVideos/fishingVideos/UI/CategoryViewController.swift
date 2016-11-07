import UIKit
import PureLayout

class CategoryViewController: UIViewController {
    
    // MARK: - Properties
    let category: [String]
    
    // MARK: - View Elements
    let tableView: UITableView
    
    // MARK: - Initializers
    init(
        category: [String]
        ) {
        
        self.category = category
        self.tableView = UITableView.newAutoLayoutView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
        self.title = ""
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: String(UITableViewCell)
        )
    }
    
    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
}


// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier( String(UITableViewCell) ) {
            cell.textLabel?.text = category[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}


// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let searchViewController = SearchViewController(keyword: category[indexPath.row])
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 32
    }
}
