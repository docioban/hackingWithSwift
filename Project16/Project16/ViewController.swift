//
//  ViewController.swift
//  Project16
//
//  Created by Macbook Pro on 11/8/20.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
        
        let London = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Capital of England")
        let Paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Capital of France")
        
        mapView.addAnnotations([London, Paris])
    }

    @IBAction func styleButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Style", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Standart", style: .default) {
            [weak self] _ in
            self?.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Satelit", style: .default) {
            [weak self] _ in
            self?.mapView.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) {
            [weak self] _ in
            self?.mapView.mapType = .hybrid
        })
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else {
            return nil
        }
        
        let indentifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: indentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: indentifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.pinTintColor = .blue
        return annotationView
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        guard let capital = view.annotation as? Capital else {
//            return
//        }
//        let ac = UIAlertController(title: capital.title, message: capital.info, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Ok", style: .default))
//        present(ac, animated: true)
//    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else {
            return
        }
        
        if let webView = storyboard?.instantiateViewController(identifier: "web") as? WebViewController {
            webView.nameCity = capital.title ?? ""
            navigationController?.pushViewController(webView, animated: true)
        }
    }
}

