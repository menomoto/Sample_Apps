import UIKit
import WebImage

class SearchTableViewCell: UITableViewCell {
    // MARK: - View Elements
    let itemImageView: UIImageView
    let titleLabel: UILabel
    let dateLabel: UILabel
    let watchButton: UIButton
    
    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        itemImageView = UIImageView.newAutoLayoutView()
        titleLabel = UILabel.newAutoLayoutView()
        dateLabel = UILabel.newAutoLayoutView()
        watchButton = UIButton(type: .System)
        watchButton.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        configureSubviews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(watchButton)
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        itemImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 2.0)
        itemImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 2.0)
        itemImageView.autoSetDimensionsToSize(CGSize(width: 320/3, height: 180/3))

        titleLabel.autoPinEdge(.Leading, toEdge: .Trailing, ofView: itemImageView, withOffset: 3.0)
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 5.0)
        titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 2.0)

        dateLabel.autoPinEdge(.Leading, toEdge: .Trailing, ofView: itemImageView, withOffset: 3.0)
        dateLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5.0)

        watchButton.autoPinEdge(.Leading, toEdge: .Trailing, ofView: dateLabel, withOffset: 3.0)
        watchButton.autoPinEdgeToSuperviewEdge(.Bottom)
        watchButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 2.0)
    }

    func configureView(video: Video) {
        itemImageView.sd_setImageWithURL(NSURL(string: video.imageUrl))

        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        titleLabel.text = video.title
        
        dateLabel.text = video.publishedAt.substringToIndex(video.publishedAt.startIndex.advancedBy(10))
        dateLabel.textColor = UIColor.lightGrayColor()
        dateLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        
        watchButton.setTitle("☆", forState: .Normal)
        watchButton.setTitle("★", forState: .Selected)
        watchButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        
    }
    
}
