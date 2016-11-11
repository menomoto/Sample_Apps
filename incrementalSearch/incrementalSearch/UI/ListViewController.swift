import UIKit
import PureLayout

class ListViewController: UIViewController {
    
    // MARK: - Properties
    var notes: [Note] = []
    
    // MARK: - View Elements
    let tableView: UITableView
    let footerView: UIView
    let newButton: UIButton
    let countLabel: UILabel
    
    // MARK: - Initializers
    init(
        ) {
        
        self.tableView = UITableView.newAutoLayoutView()
        self.footerView = UIView.newAutoLayoutView()
        self.newButton = UIButton(type: .System)
        self.newButton.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel = UILabel.newAutoLayoutView()

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
        configureSubviews()
        addConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        request()
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
        title = "メモ一覧"
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(newButton)
        footerView.addSubview(countLabel)
    }
    
    private func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: String(UITableViewCell)
        )
        
        footerView.layer.borderWidth = 0.5
        footerView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).CGColor
        footerView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        
        countLabel.font = UIFont.boldSystemFontOfSize(12)
        
        newButton.setTitle("メモ追加", forState: .Normal)
        newButton.addTarget(
            self,
            action: #selector(didTapNewButton(_:)),
            forControlEvents: .TouchUpInside
        )
    }
    
    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
        
        footerView.autoPinEdgeToSuperviewEdge(.Left)
        footerView.autoPinEdgeToSuperviewEdge(.Right)
        footerView.autoPinEdgeToSuperviewEdge(.Bottom)
        footerView.autoSetDimension(.Height, toSize: 48)

        countLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        countLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
        
        newButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        newButton.autoAlignAxisToSuperviewAxis(.Horizontal)
    }
    
    private func request() {
        let notesManager = NotesManager()
        notes = notesManager.get()
        
        countLabel.text = "\(notes.count) Notes"
        
        tableView.reloadData()
    }
    
    @objc private func didTapNewButton(sender: UIButton) {
        let noteViewController = NoteViewController(note: Note())
        navigationController?.pushViewController(
            noteViewController,
            animated: true
        )
    }
    
}


// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(
            style: UITableViewCellStyle.Subtitle,
            reuseIdentifier: "Cell"
        )

        cell.textLabel?.text = notes[indexPath.row].memo
        cell.detailTextLabel?.textColor = UIColor(white: 0.1, alpha: 0.3)
        cell.detailTextLabel?.text = notes[indexPath.row].id

        return cell
    }
}


// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let noteViewController = NoteViewController(note: notes[indexPath.row])
        navigationController?.pushViewController(noteViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.editing = editing
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let notesManager = NotesManager()
        notesManager.delete(notes[indexPath.row].id)
        notes.removeAtIndex(indexPath.row)
        countLabel.text = "\(notes.count) Notes"

        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}
