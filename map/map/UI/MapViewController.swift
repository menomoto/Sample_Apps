import UIKit
import MapKit
import PureLayout

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    var locationManager: CLLocationManager?
    
    // MARK: - View Elements
    let mapView: MKMapView
    
    // MARK: - Initializers
    init() {
        mapView = MKMapView.newAutoLayoutView()
        locationManager = CLLocationManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        if let _ = locationManager {
            locationManager?.delegate = self
            
            locationManager?.requestAlwaysAuthorization()
            locationManager?.startUpdatingLocation()
        }
            
        let status = CLLocationManager.authorizationStatus()
        switch status{
        case .Restricted, .Denied:
            break
        case .NotDetermined:
            // iOS8での位置情報追跡リクエストの方法
            if ((locationManager?.respondsToSelector("requestWhenInUseAuthorization")) != nil){
              
                locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
            }else{
                locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                locationManager?.startUpdatingLocation()
            }
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            // 従来の位置情報追跡リクエストの方法
            locationManager?.startUpdatingLocation()
        default:
            break
        }
    
        addSubviews()
        configureSubviews()
        addConstraints()
    }
    
    // MARK: - View Setup
    private func addSubviews() {
        view.addSubview(mapView)
    }
    
    private func configureSubviews() {
    }
    
    private func addConstraints() {
        mapView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    // MARK: - Action
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        let latitude = newLocation.coordinate.latitude
        let longitude = newLocation.coordinate.longitude
        let location = CLLocationCoordinate2DMake(latitude,longitude)
        
        mapView.setCenterCoordinate(location, animated: true)
        
        var region: MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
        
        pointAnnotation.coordinate = location
        pointAnnotation.title = "現在地"
        
        mapView.addAnnotation(pointAnnotation)
        mapView.setRegion(region, animated: true)
        
        //地図の形式
        mapView.mapType = MKMapType.Standard
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
}


//extension MapViewController {
//    // MARK: - MKMapView delegate
//    // Called when the region displayed by the map view is about to change
//    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        print(__FUNCTION__)
//    }
//    
//    // Called when the annotation was added
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//        
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView?.animatesDrop = true
//            pinView?.canShowCallout = true
//            pinView?.draggable = true
//            pinView?.pinColor = .Purple
//            
//            let rightButton: AnyObject! = UIButton(type: UIButtonType.DetailDisclosure)
//            pinView?.rightCalloutAccessoryView = rightButton as? UIView
//        }
//        else {
//            pinView?.annotation = annotation
//        }
//        
//        return pinView
//    }
//    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        print(__FUNCTION__)
//        if control == view.rightCalloutAccessoryView {
//            performSegueWithIdentifier("toTheMoon", sender: self)
//        }
//    }
//    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
//        if newState == MKAnnotationViewDragState.Ending {
//            let droppedAt = view.annotation?.coordinate
//            print(droppedAt)
//        }
//    }
//}
