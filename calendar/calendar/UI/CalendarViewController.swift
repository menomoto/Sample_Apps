import UIKit
import PureLayout

class CalendarViewController: UIViewController {
    
    private struct Constant {
    }

    // MARK: - Properties
    
    // MARK: - View Elements
    let headerView: UIView
    let dateLabel: UILabel
    
    let nextButton: UIButton
    let prevButton: UIButton
    
    let calendarCollectionView: UICollectionView
    
    // MARK: - Initializers
    init() {
        headerView = UIView.newAutoLayoutView()
        dateLabel = UILabel.newAutoLayoutView()
        
        nextButton = UIButton(type: .System)
        prevButton = UIButton(type: .System)
        
        calendarCollectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        addSubviews()
        configureSubviews()
        addConstraints()
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(dateLabel)
        
        headerView.addSubview(nextButton)
        headerView.addSubview(prevButton)

        view.addSubview(calendarCollectionView)
    }
    
    private func configureSubviews() {
        headerView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        let current = NSCalendar.currentCalendar().components(
            [.Year, .Month, .Day],
            fromDate: NSDate()
        )
        dateLabel.text = String(current.year) + "/" + String(current.month)
        dateLabel.font = UIFont.boldSystemFontOfSize(16)
        
        prevButton.setTitle("◀", forState: .Normal)
        prevButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        prevButton.addTarget(
            self,
            action: #selector(didTapPrevButton(_:)),
            forControlEvents: .TouchUpInside
        )

        nextButton.setTitle("▶", forState: .Normal)
        nextButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        nextButton.addTarget(
            self,
            action: #selector(didTapNextButton(_:)),
            forControlEvents: .TouchUpInside
        )
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        calendarCollectionView.registerClass(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: String(CalendarCollectionViewCell))
        calendarCollectionView.backgroundColor = UIColor(white: 0.98, alpha: 1)
    }
    
    private func addConstraints() {
        headerView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        headerView.autoPinEdgeToSuperviewEdge(.Left)
        headerView.autoPinEdgeToSuperviewEdge(.Right)
        headerView.autoSetDimension(.Height, toSize: 60)
        
        dateLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
        dateLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        
        prevButton.autoAlignAxisToSuperviewAxis(.Horizontal)
        prevButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        
        nextButton.autoAlignAxisToSuperviewAxis(.Horizontal)
        nextButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        
        calendarCollectionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerView)
        calendarCollectionView.autoPinEdgeToSuperviewEdge(.Left)
        calendarCollectionView.autoPinEdgeToSuperviewEdge(.Right)
        calendarCollectionView.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    // MARK: - Actions
    @objc private func didTapPrevButton(sender: UIButton?) {
    }
    
    @objc private func didTapNextButton(sender: UIButton?) {
    }
    
    // MARK: - Private func
    private func firstDateOfMonth() -> NSDate? {
        let components = NSCalendar.currentCalendar().components(
            [.Year, .Month, .Day],
            fromDate: NSDate()
        )
        components.day = 1
        if let firstDateMonth = NSCalendar.currentCalendar().dateFromComponents(components) {
            return firstDateMonth
        }
        return nil
    }
        
    private func numberOfItems() -> Int {
        if let firstDateOfMonth = firstDateOfMonth() {
            return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.WeekOfMonth, inUnit: NSCalendarUnit.Month, forDate: firstDateOfMonth).length * 7
        }
        return 0
    }
    
    func conversionDateFormat(indexPath: NSIndexPath) -> String {
        guard let firstDateOfMonth = firstDateOfMonth() else {
            return ""
        }
            
        let ordinalityOfFirstDay = NSCalendar.currentCalendar().ordinalityOfUnit(
            NSCalendarUnit.Day,
            inUnit: NSCalendarUnit.WeekOfMonth,
            forDate: firstDateOfMonth
        )
        
        var currentMonthOfDates = [NSDate]()
        for i in 0 ..< numberOfItems() {
            let dateComponents = NSDateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            if let date = NSCalendar.currentCalendar().dateByAddingComponents(
                dateComponents,
                toDate: firstDateOfMonth,
                options: NSCalendarOptions(rawValue: 0)) {
                currentMonthOfDates.append(date)
            }
        }

        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        return formatter.stringFromDate(currentMonthOfDates[indexPath.row])
    }

}



// MARK: - UITableViewDataSource
extension CalendarViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(CalendarCollectionViewCell), forIndexPath: indexPath ) as? CalendarCollectionViewCell
        {
            let day = conversionDateFormat(indexPath)
            cell.configureView(indexPath.row, date: day)
            cell.backgroundColor = UIColor.whiteColor()
            
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenSize:CGSize = UIScreen.mainScreen().bounds.size
        let width = ( screenSize.width - (2 * 8) ) / 7
        let cellSize: CGSize = CGSizeMake( width, width)
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }

}

