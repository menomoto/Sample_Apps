import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    // MARK: - View Elements
    let dayLabel: UILabel
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        dayLabel = UILabel.newAutoLayoutView()
        
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
        contentView.addSubview(dayLabel)
    }
    
    private func configureSubviews() {}
    
    private func addConstraints() {
        dayLabel.autoAlignAxisToSuperviewMarginAxis(.Vertical)
        dayLabel.autoAlignAxisToSuperviewMarginAxis(.Horizontal)
    }
    
    func configureView(index: Int, date: String) {
        dayLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        dayLabel.text = date

        if index % 7 == 0 {
            dayLabel.textColor = UIColor.redColor()
        } else if (index % 7 == 6) {
            dayLabel.textColor = UIColor.blueColor()
        }
    }
    
}
