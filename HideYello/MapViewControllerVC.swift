//
//  MapViewControllerVC.swift
//  RXVVM
//
//  Created by Paresh Prajapati on 10/09/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import UIKit
import MapKit

class MapViewControllerVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setTwoLocation()
    }
    
    func setTwoLocation() {
        let initialLocation = CLLocation(latitude: 23.0225, longitude: 72.5714)
        let toLocation = CLLocation(latitude: 22.3072, longitude: 73.1812)
        let start = [initialLocation, toLocation];
        self.mapView.addAnnotations(coords: start)
        self.mapView.fitAllAnnotations()
    }
    
}

extension MapViewControllerVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        if annotation is MKUserLocation {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "user-pin")

            // if you want a disclosure button, you'd might do something like:
            //
            // let detailButton = UIButton(type: .detailDisclosure)
            // annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

}
extension MKMapView
{
    
    func addAnnotations(coords: [CLLocation]){
        var i = 0
        for coord in coords{
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                      longitude: coord.coordinate.longitude)
            let anno = MKPointAnnotation()
            anno.title = i == 0 ? "Ahmedabad": "Baroda"
            anno.coordinate = CLLCoordType
            self.addAnnotation(anno)
            i += 1
        }
    }
    
    func fitAllAnnotations() {
        var zoomRect = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1);
            zoomRect = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
}
