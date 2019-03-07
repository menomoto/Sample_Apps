import Foundation
import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let previewView = UIView()
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    private(set) var previewLayer : AVCaptureVideoPreviewLayer?
    private(set) var device: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        configureSubviews()
        
        captureSession.sessionPreset = .photo

        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        
        captureSession.startRunning()
    }
    
    private func configureSubviews() {
        previewView.backgroundColor = .clear
        view.addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        previewView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        previewView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        previewView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
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

