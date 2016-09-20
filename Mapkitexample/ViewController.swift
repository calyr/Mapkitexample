//
//  ViewController.swift
//  Mapkitexample
//
//  Created by Roberto Carlos Callisaya Mamani on 9/19/16.
//  Copyright © 2016 Roberto Carlos Callisaya Mamani. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension CLLocationCoordinate2D {
    
    func distanceInMetersFrom(otherCoord : CLLocationCoordinate2D) -> CLLocationDistance {
        let firstLoc = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let secondLoc = CLLocation(latitude: otherCoord.latitude, longitude: otherCoord.longitude)
        return firstLoc.distanceFromLocation(secondLoc)
    }
    
}


class ViewController: UIViewController, CLLocationManagerDelegate {

    var puntos:[CLLocationCoordinate2D] = []

    let initialLocation = CLLocation(latitude: 37.33617936, longitude: -122.02327117)
    
    let regionRadius: CLLocationDistance = 100
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapa.setRegion(coordinateRegion, animated: true)
    }
    @IBOutlet weak var mapa: MKMapView!
    private let manejador = CLLocationManager()
    
    @IBAction func satelite(sender: UIBarButtonItem) {
        self.mapa.mapType  = MKMapType.Satellite
    }
    @IBAction func mapa(sender: UIBarButtonItem) {
        self.mapa.mapType  = .Standard

    }
    @IBAction func hibrido(sender: UIBarButtonItem) {
        self.mapa.mapType  = MKMapType.Hybrid

    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        centerMapOnLocation(initialLocation)
        // Do any additional setup after loading the view, typically from a nib.
    
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        manejador.distanceFilter = 50
        
//        var punto = CLLocationCoordinate2D()
//        
//        punto.latitude = -17.383853
//        punto.longitude = -66.180009
//        
//        
//        let pin = MKPointAnnotation()
//        pin.title = "Cochabamba"
//        pin.subtitle = "Cercado"
//        pin.coordinate = punto
//        mapa.addAnnotation(pin)
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            print("Se tiene permiso")
        }else{
            print("No se tiene permiso")
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var punto = CLLocationCoordinate2D()
        
        
        punto.latitude = manager.location!.coordinate.latitude
        punto.longitude = manager.location!.coordinate.longitude
        
        puntos.append(punto)
        centerMapOnLocation(CLLocation(latitude: punto.latitude, longitude: punto.longitude))

        let pin = MKPointAnnotation()
        pin.title = "Lat =\(punto.latitude) , Long = \(punto.longitude)"
        let distance = puntos.first!.distanceInMetersFrom(puntos.last!)
        pin.subtitle = "Distancia = \(distance) Metros."
    
        pin.coordinate = punto
        mapa.addAnnotation(pin)
        print("Ingreso a actualizar la posición LAT = \(punto.latitude) , LONG = \(punto.longitude)" )
        
    }
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        // simple and inefficient example
//        
//        let annotationView = MKPinAnnotationView()
//        
//        annotationView.pinTintColor = UIColor.purpleColor()
//        
//        return annotationView
//    }

    
    


}

