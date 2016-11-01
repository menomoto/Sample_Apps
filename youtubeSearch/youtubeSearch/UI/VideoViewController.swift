import UIKit
import PureLayout
import YouTubeiOSPlayerHelper

class VideoViewController: UIViewController, YTPlayerViewDelegate {
    
    // MARK: - Properties
    private var video: Video
    
    // MARK: - View Elements
    let playerView: YTPlayerView

    // MARK: - Initializers
    init(video: Video) {
        
        self.video = video
        self.playerView = YTPlayerView.newAutoLayoutView()
        
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
        self.title = video.title
    }
    
    private func addSubviews() {
        view.addSubview(playerView)
    }
    
    private func configureSubviews() {
        playerView.delegate = self
        playerView.loadWithVideoId(video.videoId, playerVars: ["playsinline":1])
    }
    
    private func addConstraints() {
        playerView.autoPinEdgeToSuperviewEdge(.Top)
        //playerView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        playerView.autoPinEdgeToSuperviewEdge(.Left)
        playerView.autoPinEdgeToSuperviewEdge(.Right)
        playerView.autoSetDimension(.Height, toSize: 380)
    }
}
