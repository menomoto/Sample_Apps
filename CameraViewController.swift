import Foundation
import UIKit
import AVFoundation

// add plist
// - NSCameraUsageDescription(カメラを使用することの許可を求める)
// - NSPhotoLibraryAddUsageDescription(写真ライブラリへのアクセスの許可を求める)

class CameraViewController: UIViewController {
    
    let previewView = UIView()
    let button = UIButton(type: .system)
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    private(set) var previewLayer : AVCaptureVideoPreviewLayer?
    private(set) var device: AVCaptureDevice?
    
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
        button.setTitle("写真を撮る", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        view.addSubview(previewView)
        view.addSubview(button)

        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        previewView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        previewView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        previewView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true

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
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        guard let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height else { return }

        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = CGRect(x: 0, y: statusBarHeight + navigationBarHeight, width: width, height: width)
        previewView.layer.insertSublayer(previewLayer, at: 0)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
            let uiImage = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        }
    }
}

