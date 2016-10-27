import UIKit

class AppRankingTableViewCell: UITableViewCell {
    // MARK: - View Elements
    let appImageView: UIImageView
    let nameLabel: UILabel
    let categoryLabel: UILabel
    
    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        appImageView = UIImageView.newAutoLayoutView()
        nameLabel = UILabel.newAutoLayoutView()
        categoryLabel = UILabel.newAutoLayoutView()
        
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
        contentView.addSubview(appImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
    }
    
    private func configureSubviews() {
        nameLabel.font = UIFont.systemFontOfSize(12)
        categoryLabel.font = UIFont.systemFontOfSize(8)
    }
    
    private func addConstraints() {

        appImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 2.0)
        appImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 2.0)
        appImageView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 2.0)
        appImageView.autoSetDimensionsToSize(CGSize(width: 32.0, height: 32.0))
        
        nameLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
        nameLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 5)
        nameLabel.autoPinEdge(.Leading, toEdge: .Trailing, ofView: appImageView, withOffset: 8.0)

        categoryLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel, withOffset: 5.0)
        categoryLabel.autoPinEdge(.Leading, toEdge: .Trailing, ofView: appImageView, withOffset: 16.0)
}
    
    func configureView(appRanking: AppRanking, index: NSIndexPath) {
        nameLabel.text = String(index.row + 1) + ". " + appRanking.name
        appImageView.image = appRanking.image
        categoryLabel.text = appRanking.categoryName
    }
}
