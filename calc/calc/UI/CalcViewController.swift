import UIKit
import PureLayout

class CalcViewController: UIViewController {
    
    private struct Constant {
        static let operateButtonLabels = "C=+-x÷"
    }
    // MARK: - Properties
    var calcResult: Int
    var isTapOperateButton: Bool
    var tapOperateButtonTitle: String
    
    // MARK: - View Elements
    let displayLabel: UILabel
    
    let button0: UIButton
    let button1: UIButton
    let button2: UIButton
    let button3: UIButton
    let button4: UIButton
    let button5: UIButton
    let button6: UIButton
    let button7: UIButton
    let button8: UIButton
    let button9: UIButton
    
    let buttonClear: UIButton
    let buttonEqual: UIButton
    let buttonPlus: UIButton
    let buttonMinus: UIButton
    let buttonMultiply: UIButton
    let buttonDevide: UIButton

    
    // MARK: - Initializers
    init() {
        displayLabel = UILabel.newAutoLayoutView()
        
        button0 = UIButton(type: UIButtonType.System)
        button1 = UIButton(type: UIButtonType.System)
        button2 = UIButton(type: UIButtonType.System)
        button3 = UIButton(type: UIButtonType.System)
        button4 = UIButton(type: UIButtonType.System)
        button5 = UIButton(type: UIButtonType.System)
        button6 = UIButton(type: UIButtonType.System)
        button7 = UIButton(type: UIButtonType.System)
        button8 = UIButton(type: UIButtonType.System)
        button9 = UIButton(type: UIButtonType.System)
        
        buttonClear    = UIButton(type: UIButtonType.System)
        buttonEqual    = UIButton(type: UIButtonType.System)
        buttonPlus     = UIButton(type: UIButtonType.System)
        buttonMinus    = UIButton(type: UIButtonType.System)
        buttonMultiply = UIButton(type: UIButtonType.System)
        buttonDevide   = UIButton(type: UIButtonType.System)
        
        calcResult = 0
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
        
        view.addSubview(button0)
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
        view.addSubview(button5)
        view.addSubview(button6)
        view.addSubview(button7)
        view.addSubview(button8)
        view.addSubview(button9)

        view.addSubview(buttonClear)
        view.addSubview(buttonEqual)
        view.addSubview(buttonPlus)
        view.addSubview(buttonMinus)
        view.addSubview(buttonMultiply)
        view.addSubview(buttonDevide)

    }
    
    private func configureSubviews() {
        displayLabel.text = "0"
        displayLabel.layer.borderWidth = 1
        displayLabel.textAlignment = NSTextAlignment.Right
        displayLabel.font = UIFont.systemFontOfSize(48)
        
        configureButton(button0, title: "0")
        configureButton(button1, title: "1")
        configureButton(button2, title: "2")
        configureButton(button3, title: "3")
        configureButton(button4, title: "4")
        configureButton(button5, title: "5")
        configureButton(button6, title: "6")
        configureButton(button7, title: "7")
        configureButton(button8, title: "8")
        configureButton(button9, title: "9")

        configureButton(buttonClear,    title: "C")
        configureButton(buttonEqual,    title: "=")
        configureButton(buttonPlus,     title: "+")
        configureButton(buttonMinus,    title: "-")
        configureButton(buttonMultiply, title: "x")
        configureButton(buttonDevide,   title: "÷")
    }
    
    private func configureButton(button: UIButton, title: String) {
        button.setTitleColor(.blackColor(), forState: .Normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10.0
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(48)
        button.addTarget(
            self,
            action: #selector(didTapButton(_:)),
            forControlEvents: .TouchUpInside
        )
    }
    
    // MARK: - Actions
    @objc private func didTapButton(sender: UIButton?) {
        if let buttonTitle = sender?.titleLabel?.text {
            if Constant.operateButtonLabels.containsString(buttonTitle) {
                didTapOperateButton(buttonTitle)
                isTapOperateButton = true
            } else {
                didTapNumericButton(buttonTitle)
                isTapOperateButton = false
            }
        }
    }
    
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
            calcResult = 0
            tapOperateButtonTitle = ""
            return
        }
        
        if tapOperateButtonTitle == "" || tapOperateButtonTitle == "=" {
            calcResult = displayNumericValue
            tapOperateButtonTitle = buttunTitle
            return
        }
        
        switch tapOperateButtonTitle {
        case "+":
            calcResult += displayNumericValue
        case "-":
            calcResult -= displayNumericValue
        case "x":
            calcResult *= displayNumericValue
        case "÷":
            calcResult /= displayNumericValue
        default:
            return
        }
        
        displayLabel.text = String(calcResult)
        tapOperateButtonTitle = buttunTitle
        
    }
}


// MARK : - Auto Layout Setting
extension CalcViewController {

    private func addConstraints() {
        let buttonWidth =
            (UIScreen.mainScreen().bounds.width - 10 * 5) / 4

        displayLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 30)
        displayLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        displayLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        
        // MARK : - Line 1
        button7.autoPinEdge(.Top, toEdge: .Bottom, ofView: displayLabel, withOffset: 10)
        button7.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        button7.autoSetDimension(.Width, toSize: buttonWidth)

        button8.autoPinEdge(.Top, toEdge: .Bottom, ofView: displayLabel, withOffset: 10)
        button8.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button7, withOffset: 10)
        button8.autoSetDimension(.Width, toSize: buttonWidth)
        
        button9.autoPinEdge(.Top, toEdge: .Bottom, ofView: displayLabel, withOffset: 10)
        button9.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button8, withOffset: 10)
        button9.autoSetDimension(.Width, toSize: buttonWidth)

        buttonPlus.autoPinEdge(.Top, toEdge: .Bottom, ofView: displayLabel, withOffset: 10)
        buttonPlus.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button9, withOffset: 10)
        buttonPlus.autoSetDimension(.Width, toSize: buttonWidth)
        buttonPlus.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)

        // MARK : - Line 2
        button4.autoPinEdge(.Top, toEdge: .Bottom, ofView: button7, withOffset: 10)
        button4.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        button4.autoSetDimension(.Width, toSize: buttonWidth)
        
        button5.autoPinEdge(.Top, toEdge: .Bottom, ofView: button8, withOffset: 10)
        button5.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button4, withOffset: 10)
        button5.autoSetDimension(.Width, toSize: buttonWidth)
        
        button6.autoPinEdge(.Top, toEdge: .Bottom, ofView: button9, withOffset: 10)
        button6.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button5, withOffset: 10)
        button6.autoSetDimension(.Width, toSize: buttonWidth)
        
        buttonMinus.autoPinEdge(.Top, toEdge: .Bottom, ofView: buttonPlus, withOffset: 10)
        buttonMinus.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button6, withOffset: 10)
        buttonMinus.autoSetDimension(.Width, toSize: buttonWidth)
        buttonMinus.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)

        // MARK : - Line 3
        button1.autoPinEdge(.Top, toEdge: .Bottom, ofView: button4, withOffset: 10)
        button1.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        button1.autoSetDimension(.Width, toSize: buttonWidth)
        
        button2.autoPinEdge(.Top, toEdge: .Bottom, ofView: button5, withOffset: 10)
        button2.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button1, withOffset: 10)
        button2.autoSetDimension(.Width, toSize: buttonWidth)
        
        button3.autoPinEdge(.Top, toEdge: .Bottom, ofView: button6, withOffset: 10)
        button3.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button2, withOffset: 10)
        button3.autoSetDimension(.Width, toSize: buttonWidth)
        
        buttonMultiply.autoPinEdge(.Top, toEdge: .Bottom, ofView: buttonMinus, withOffset: 10)
        buttonMultiply.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button3, withOffset: 10)
        buttonMultiply.autoSetDimension(.Width, toSize: buttonWidth)
        buttonMultiply.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)

        // MARK : - Line 4
        button0.autoPinEdge(.Top, toEdge: .Bottom, ofView: button1, withOffset: 10)
        button0.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        button0.autoSetDimension(.Width, toSize: buttonWidth)
        
        buttonClear.autoPinEdge(.Top, toEdge: .Bottom, ofView: button2, withOffset: 10)
        buttonClear.autoPinEdge(.Leading, toEdge: .Trailing, ofView: button0, withOffset: 10)
        buttonClear.autoSetDimension(.Width, toSize: buttonWidth)
        
        buttonEqual.autoPinEdge(.Top, toEdge: .Bottom, ofView: button3, withOffset: 10)
        buttonEqual.autoPinEdge(.Leading, toEdge: .Trailing, ofView: buttonClear, withOffset: 10)
        buttonEqual.autoSetDimension(.Width, toSize: buttonWidth)
        
        buttonDevide.autoPinEdge(.Top, toEdge: .Bottom, ofView: buttonMultiply, withOffset: 10)
        buttonDevide.autoPinEdge(.Leading, toEdge: .Trailing, ofView: buttonEqual, withOffset: 10)
        buttonDevide.autoSetDimension(.Width, toSize: buttonWidth)
        buttonDevide.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
    }
}

