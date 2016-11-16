import UIKit

class NoteViewController: UIViewController {
    // MARK: - Properties
    var note: Note
    var imagePicker: UIImagePickerController
    
    // MARK: - View Elements
    let memoTextView: UITextView
    
    // MARK: - Initializers
    init(
        note: Note
        ) {
        self.note = note
        
        self.memoTextView = UITextView.newAutoLayoutView()
        self.imagePicker = UIImagePickerController()
        
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
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil && !memoTextView.text.isEmpty {
            let notesManager = NotesManager()
            note.memo = memoTextView.text
            notesManager.save(note)
        }
    }
    
    private func configureNavigationBar() {
        title = note.id.isEmpty ? "メモ追加" : "メモ編集"
        let cameraButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Camera,
            target: self,
            action: #selector(didTapCameraButton(_:))
        )

        navigationItem.rightBarButtonItem = cameraButton
    }
    
    private func addSubviews() {
        view.addSubview(memoTextView)
    }

    private func configureSubviews() {
        memoTextView.text = note.id.isEmpty ? "" : note.memo
        if note.image.size.width > 0 {
            attachImageTextView(note.image)
        }
        memoTextView.scrollEnabled = true
    }

    private func addConstraints() {
        memoTextView.autoPinEdgesToSuperviewEdges()
    }

    @objc private func didTapCameraButton(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func attachImageTextView(image: UIImage) {

        let attachment = NSTextAttachment()
        attachment.image = image
        guard let width = attachment.image?.size.width,
            let scaleImage = image.CGImage else { return }
        
        let scale = width / (UIScreen.mainScreen().bounds.width - 10)

        attachment.image = UIImage(
            CGImage: scaleImage,
            scale: scale,
            orientation: .Up
        )
        
        let attString = NSAttributedString(attachment: attachment)
        memoTextView.textStorage.insertAttributedString(
            attString,
            atIndex: 0
        )

    }
}

extension NoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            note.image = image
            attachImageTextView(image)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
