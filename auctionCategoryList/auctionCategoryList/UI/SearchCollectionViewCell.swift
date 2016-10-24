import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    // MARK: - View Elements
    let itemImageView: UIImageView
    let titleLabel: UILabel
    let priceLabel: UILabel
    let bidLabel: UILabel
    let endTimeLabel: UILabel
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        itemImageView = UIImageView.newAutoLayoutView()

        titleLabel = UILabel.newAutoLayoutView()
        priceLabel = UILabel.newAutoLayoutView()
        bidLabel = UILabel.newAutoLayoutView()
        endTimeLabel = UILabel.newAutoLayoutView()
        
        super.init(frame: frame)
        
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
        contentView.addSubview(priceLabel)
        contentView.addSubview(bidLabel)
        contentView.addSubview(endTimeLabel)
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        itemImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 2)
        itemImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 2)
        itemImageView.autoPinEdgeToSuperviewEdge(.Right, withInset: 2)

        titleLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: itemImageView, withOffset: 3.0)
        titleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 2)
        titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 2)

        priceLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 3.0)
        priceLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 2)
        priceLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 2)

        endTimeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceLabel, withOffset: 3.0)
        endTimeLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 2)
        endTimeLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)

        bidLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: priceLabel, withOffset: 3.0)
        bidLabel.autoPinEdge(.Left, toEdge: .Right, ofView: endTimeLabel, withOffset: 10.0)
        bidLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)

    }
    
    func configureView(product: Product) {
        itemImageView.image = product.image

        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        titleLabel.text = product.title

        priceLabel.font = UIFont.boldSystemFontOfSize(UIFont.smallSystemFontSize())
        priceLabel.text = "現在 " + String(product.price) + "円"

        endTimeLabel.font = UIFont.systemFontOfSize(CGFloat(10))
        endTimeLabel.text = "🕒" + product.endTime

        bidLabel.font = UIFont.systemFontOfSize(CGFloat(10))
        bidLabel.text = "🔨" + String(product.bidCount)
    }
}
