import UIKit
import PureLayout
import YFoundation


class CategoryListViewController: UIViewController {
    
    
    // MARK: - Properties
    private var categoryList: CategoryTree = CategoryTree()
    private var products: [Product] = [Product]()

    // MARK: - View Elements
    let tableView: UITableView
    var categoryId: String
    
    // MARK: - Initializers
    init(
        categoryId: String
        )
    {
        self.tableView = UITableView.newAutoLayoutView()
        self.categoryId = categoryId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()        
        apiRequest()
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

//        let backButton = UIBarButtonItem()
//        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "System", size: 12)!], forState: .Normal)
//        navigationItem.backBarButtonItem = backButton
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(
            CategoryListTableViewCell.self,
            forCellReuseIdentifier: String(CategoryListTableViewCell)
        )
    }

    private func addConstraints() {

        tableView.autoPinEdgeToSuperviewEdge(.Top)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)
    }
    
    // MARK: - API
    private func apiRequest() {
        let url = Urls.category.rawValue + categoryId
        ApiClient.request(url, completion:{ data, res, error in
            self.categoryList = Parser.categoryListParse(data)
            self.tableView.reloadData()
            
            self.title = self.categoryList.categoryName
        })
    }
    
}


// MARK: - UITableViewDataSource
extension CategoryListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.childCategory.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier( String(CategoryListTableViewCell) ) as? CategoryListTableViewCell
        {
            cell.configureView(categoryList.childCategory[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
}

extension CategoryListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if categoryList.childCategory[indexPath.row].isLeaf {
            let viewController = SearchViewController(category: categoryList.childCategory[indexPath.row])
            self.navigationController?.pushViewController(viewController, animated: true)
            
        } else {
            let viewController = CategoryListViewController(categoryId: categoryList.childCategory[indexPath.row].categoryId)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
