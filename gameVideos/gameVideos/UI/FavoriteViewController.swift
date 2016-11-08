import UIKit
import PureLayout

class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    private var videos: [Video] = [Video]()
    
    // MARK: - View Elements
    let tableView: UITableView
    
    // MARK: - Initializers
    init(
        ) {
        
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
    
    override func viewWillAppear(animated: Bool) {
        request()
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
        title = "お気に入り"
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureSubviews() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(
            SearchTableViewCell.self,
            forCellReuseIdentifier: String(SearchTableViewCell)
        )
    }
    
    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    private func request() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        //userDefaults.removeObjectForKey(Constants.userDefaultKey)  // DELETE
        var favoriteVideos: Dictionary<String, String> = [:]
        if let saveFavoriteVideos = userDefaults.dictionaryForKey(Constants.userDefaultKey) as? Dictionary<String, String> {
            favoriteVideos = saveFavoriteVideos
        }
        
        self.videos = []
        for (key, value) in favoriteVideos {
            var video = Video()
            video.videoId = key
            let videoArray = value.componentsSeparatedByString(",")
            video.title = videoArray[0]
            video.imageUrl = videoArray[1]
            video.publishedAt = videoArray[2]
            
            self.videos.append(video)
        }
        self.tableView.reloadData()
    }
    
}


// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier( String(SearchTableViewCell) ) as? SearchTableViewCell {
            cell.configureView(videos[indexPath.row])
            
            cell.watchButton.setTitle("★", forState: .Normal)
            cell.watchButton.tag = indexPath.row
            cell.watchButton.titleLabel?.font = UIFont.systemFontOfSize(20)
            
            
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let videoViewController = VideoViewController(video: videos[indexPath.row])
        navigationController?.pushViewController(videoViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
}
