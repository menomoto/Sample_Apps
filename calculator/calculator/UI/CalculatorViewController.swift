import UIKit
import PureLayout

class CalculatorViewController: UIViewController {
    
    private struct Constants {
        static let calculatorLabels = "789+456-123x0C=÷"
        static let operateButtonLabels = "C=+-x÷"
    }
    // MARK: - Properties
    var calculatorResult: Int
    var isTapOperateButton: Bool
    var tapOperateButtonTitle: String
    
    // MARK: - View Elements
    let displayLabel: UILabel
    let collectionView: UICollectionView

    // MARK: - Initializers
    init() {
        displayLabel = UILabel.newAutoLayoutView()
        
        collectionView = UICollectionView(
            frame: CGRectZero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        calculatorResult = 0
        isTapOperateButton = false
        tapOperateButtonTitle = ""
        
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
        view.addSubview(displayLabel)
        view.addSubview(collectionView)
    }
    
    private func configureSubviews() {
        displayLabel.text = "0"
        displayLabel.layer.borderWidth = 1
        displayLabel.textAlignment = NSTextAlignment.Right
        displayLabel.font = UIFont.systemFontOfSize(48)
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: String(UICollectionViewCell))
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)

    }
    
    private func addConstraints() {
        displayLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 30)
        displayLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        displayLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        
        collectionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: displayLabel)
        collectionView.autoPinEdgeToSuperviewEdge(.Left)
        collectionView.autoPinEdgeToSuperviewEdge(.Right)
        collectionView.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    // MARK: - Actions
    private func didTapNumericButton(buttunTitle: String) {
        if let displayLabelText = displayLabel.text {
            displayLabel.text =
                (displayLabel.text == "0" || isTapOperateButton )
                ? buttunTitle : displayLabelText + buttunTitle
        }
    }
    
    private func didTapOperateButton(buttunTitle: String) {
        guard let diplayLabelText = displayLabel.text,
            let displayNumericValue = Int(diplayLabelText) else {
            return
        }
        
        if buttunTitle == "C" {
            displayLabel.text = "0"
            calculatorResult = 0
            tapOperateButtonTitle = ""
            return
        }
        
        if tapOperateButtonTitle == "" || tapOperateButtonTitle == "=" {
            calculatorResult = displayNumericValue
            tapOperateButtonTitle = buttunTitle
            return
        }
        
        switch tapOperateButtonTitle {
        case "+":
            calculatorResult += displayNumericValue
        case "-":
            calculatorResult -= displayNumericValue
        case "x":
            calculatorResult *= displayNumericValue
        case "÷":
            calculatorResult /= displayNumericValue
        default:
            return
        }
        
        displayLabel.text = String(calculatorResult)
        tapOperateButtonTitle = buttunTitle
    }
    
    private func configureCalcLabel(cell: UICollectionViewCell, label: String) {
        let calcLabel = UILabel.newAutoLayoutView()
        calcLabel.text = label
        calcLabel.font = UIFont.systemFontOfSize(48)
        cell.addSubview(calcLabel)
        calcLabel.autoAlignAxisToSuperviewMarginAxis(.Horizontal)
        calcLabel.autoAlignAxisToSuperviewMarginAxis(.Vertical)
    }
}


// MARK: - UITableViewDataSource
extension CalculatorViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.calculatorLabels.characters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                String(UICollectionViewCell),
                forIndexPath: indexPath) as UICollectionViewCell

        cell.backgroundColor = UIColor.whiteColor()
        cell.tag = indexPath.row
        
        let labels = Constants.calculatorLabels.characters.map { String($0) }
        configureCalcLabel(cell, label: labels[indexPath.row])

        return cell
    }
}

extension CalculatorViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            let labels = Constants.calculatorLabels.characters.map { String($0) }
            let title = labels[cell.tag]
            
            if Constants.operateButtonLabels.containsString(title) {
                didTapOperateButton(title)
                isTapOperateButton = true
            } else {
                didTapNumericButton(title)
                isTapOperateButton = false
            }
        }
    }
}

extension CalculatorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenSize:CGSize = UIScreen.mainScreen().bounds.size
        let width = ( screenSize.width - (10 * 5) ) / 4
        let cellSize: CGSize = CGSizeMake( width, width)
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
