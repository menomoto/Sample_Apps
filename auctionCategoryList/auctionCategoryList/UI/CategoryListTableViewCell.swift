import UIKit

class CategoryListTableViewCell: UITableViewCell {
    // MARK: - View Elements
    let categoryLabel: UILabel
    
    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        contentView.addSubview(categoryLabel)
    }
    
    private func configureSubviews() {
        categoryLabel.font = UIFont.systemFontOfSize(12)
    }
    
    private func addConstraints() {
        
        categoryLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
        categoryLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 15.0)
        categoryLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 15.0)
    }
    
    func configureView(category: Category) {
        if category.numOfAuctions == "" {
            categoryLabel.text = category.categoryName
        } else {
            categoryLabel.text = category.categoryName + " (" + category.numOfAuctions + ")"
        }
    }
}
