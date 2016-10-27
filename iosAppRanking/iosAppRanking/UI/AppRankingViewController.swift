import UIKit
import PureLayout

class AppRankingViewController: UIViewController {
    
    // MARK: - Properties
    private var appRankings: [AppRanking] = [AppRanking]()

    // MARK: - View Elements
    let tableView: UITableView
    
    // MARK: - Initializers
    init(
        )
    {
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
        apiRequest()
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
        title = "App Store Free Top 30"
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(
            AppRankingTableViewCell.self,
            forCellReuseIdentifier: String(AppRankingTableViewCell)
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
        let url = Urls.appRanking.rawValue
        ApiClient.request(url, completion:{ data, res, error in
            let appRankingParser = AppRankingParser()
            self.appRankings = appRankingParser.parse(data)
            self.tableView.reloadData()
        })
    }
    
}


// MARK: - UITableViewDataSource
extension AppRankingViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appRankings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier( String(AppRankingTableViewCell) ) as? AppRankingTableViewCell
        {
            cell.configureView(appRankings[indexPath.row], index: indexPath)
            
            return cell
        }
        return UITableViewCell()
    }
}

extension AppRankingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 36
    }
}
