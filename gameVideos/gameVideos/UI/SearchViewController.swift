import UIKit
import PureLayout

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private var videos: [Video] = [Video]()
    private var keyword: String
    
    // MARK: - View Elements
    let searchBar: UISearchBar
    let tableView: UITableView
    
    // MARK: - Initializers
    init(
        keyword: String
        ) {
        
        self.keyword = keyword
        self.searchBar = UISearchBar.newAutoLayoutView()
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
        searchBar.becomeFirstResponder()
        if !keyword.isEmpty {
            searchBar.text = keyword
            request(keyword)
        }
        
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
        title = "検索"
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func configureSubviews() {
        searchBar.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(
            SearchTableViewCell.self,
            forCellReuseIdentifier: String(SearchTableViewCell)
        )
    }
    
    private func addConstraints() {
        searchBar.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        searchBar.autoPinEdgeToSuperviewEdge(.Left)
        searchBar.autoPinEdgeToSuperviewEdge(.Right)
        
        tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: searchBar)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)
    }
    
    private func request(query: String) {
        
        guard let encodeQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else { return }
        let url = Constants.searchUrl + encodeQuery
        ApiClient.request(url, completion:{ data, res, error in
            self.videos = Parser.searchListParse(data)
            self.tableView.reloadData()
        })
        
    }
    
}


// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        request(query)
    }
}


// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier( String(SearchTableViewCell) ) as? SearchTableViewCell {
            cell.configureView(videos[indexPath.row])
            
            cell.watchButton.setTitle("☆", forState: .Normal)
            cell.watchButton.tag = indexPath.row
            cell.watchButton.addTarget(
                self,
                action: #selector(didTapWatchButton(_:)),
                forControlEvents: .TouchUpInside
            )
            cell.watchButton.titleLabel?.font = UIFont.systemFontOfSize(20)

            
            return cell
        }
        return UITableViewCell()
    }
    
    @objc private func didTapWatchButton(selector: UIButton) {
        selector.setTitle("★", forState: .Normal)
        
        let video = videos[selector.tag]

        let userDefaults = NSUserDefaults.standardUserDefaults()
        var favoriteVideos: Dictionary<String, String> = [:]
        if let saveFavoriteVideos = userDefaults.dictionaryForKey(Constants.userDefaultKey) as? Dictionary<String, String> {
            favoriteVideos = saveFavoriteVideos
        }
        favoriteVideos[video.videoId] = video.title + "," + video.imageUrl + "," + video.publishedAt
        userDefaults.setObject(
            favoriteVideos,
            forKey: Constants.userDefaultKey
        )
    }

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let videoViewController = VideoViewController(video: videos[indexPath.row])
        navigationController?.pushViewController(videoViewController, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
}
