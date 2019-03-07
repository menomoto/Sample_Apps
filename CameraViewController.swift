import Foundation
import UIKit
import AVFoundation

// add plist
// - NSCameraUsageDescription(カメラを使用することの許可を求める)
// - NSPhotoLibraryAddUsageDescription(写真ライブラリへのアクセスの許可を求める)

class CameraViewController: UIViewController {
    let previewView = UIView()
    let collectionView: UICollectionView
    let button = UIButton(type: .system)
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    private(set) var previewLayer : AVCaptureVideoPreviewLayer?
    private(set) var device: AVCaptureDevice?
    
    private(set) var images: [UIImage] = []
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 64, height: 64)
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureSubviews()
        
        captureSession.sessionPreset = .photo

        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        
        captureSession.startRunning()
    }
    
    private func configureSubviews() {
        previewView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        button.setTitle("写真を撮る", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        view.addSubview(previewView)
        view.addSubview(collectionView)
        view.addSubview(button)

        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        previewView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        previewView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        previewView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: 16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 64).isActive = true

        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72).isActive = true
    }
    
    @objc private func didTapButton() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.isAutoStillImageStabilizationEnabled = true
        self.photoOutput.capturePhoto(with: settings, delegate: self)
    }

    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )
        deviceDiscoverySession.devices.forEach {
            if $0.position == .back {
                device = $0
            }
        }
    }
    
    private func setupInputOutput() {
        guard let currentDevice = device else { return }
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
            captureSession.addInput(captureDeviceInput)
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput)
        } catch {
            print(error)
        }
    }
    
    private func setupPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let previewLayer = self.previewLayer else { return }
        let width = UIScreen.main.bounds.width

        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = CGRect(x: 0, y: 0, width: width, height: width)
        previewView.layer.insertSublayer(previewLayer, at: 0)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
            let image = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            images.append(image)
            collectionView.reloadData()
        }
    }
}

extension CameraViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        let image: UIImage? = images.count > indexPath.item ? images[indexPath.item] : nil
        cell.set(image: image)
        return cell
    }
}

class ImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .lightGray
        
        contentView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func set(image: UIImage?) {
        imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

