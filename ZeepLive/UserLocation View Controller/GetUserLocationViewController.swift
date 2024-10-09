////
////  GetUserLocationViewController.swift
////  ZeepLive
////
////  Created by Creative Frenzy on 28/12/23.
////
//

import Foundation
import CoreLocation

class GetUserLocationViewController: NSObject, CLLocationManagerDelegate {
    
    static let shared = GetUserLocationViewController()
    
    let locationManager = CLLocationManager()
    var hasRequestedAuthorization = false
    
    var placeMark: CLPlacemark?
    
    lazy var userCity = String()
    lazy var userCountry = String()
    lazy var isLocationUpdated: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        startLocationUpdates()
    }
    
//    func startLocationUpdates() {
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
//            hasRequestedAuthorization = true
//        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        }
//    }
    func startLocationUpdates() {
            let authorizationStatus = CLLocationManager.authorizationStatus()
            switch authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                hasRequestedAuthorization = true
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                // Handle case when location access is denied or restricted
                print("Location access denied or restricted.")
            @unknown default:
                break
            }
        }
    
    // Call this method from your view controller to start location updates
    func getLocation() {
        if !hasRequestedAuthorization {
            startLocationUpdates()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        locationManager.stopUpdatingLocation()
        fetchCityAndCountry(from: location) { [weak self] city, country, postalCode, subLocality, error in
            guard let self = self else { return }
            
            guard let city = city, let country = country, let postalCode = postalCode, let subLocality = subLocality, error == nil else { return }
            
            self.userCity = city
            self.userCountry = country
            
            let a = UserDefaults.standard.string(forKey: "location") ?? ""
            print(a)
            
            if (isLocationUpdated == true && a != self.userCity) {
                
                self.sendLocation(country: country, city: city, lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                print("User ki location change hui hai. ab api call kra do.")
            }
                
            UserDefaults.standard.set(city, forKey: "location")
            
            if !self.isLocationUpdated {
                self.sendLocation(country: country, city: city, lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                isLocationUpdated = true
            }
        }
    }

    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ postalCode: String?, _ subLocality: String? , _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       placemarks?.first?.postalCode,
                       placemarks?.first?.subLocality,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error：\(error.localizedDescription)")
    }
    
    func sendLocation(country: String, city: String, lat: Double, lng: Double) {
        let url = "https://zeep.live/api/update-lat-lng?country=\(country)&user_city=\(city)&lat=\(lat)&lng=\(lng)"
        print("The url for sending location is: \(url)")
        ApiWrapper.sharedManager().sendUserLocation(url: url) { [weak self] (value) -> Void in
            guard let self = self else { return }
            isLocationUpdated = true
            print(value)
        }
    }
}


//import Foundation
//import CoreLocation
//
//class GetUserLocationViewController: NSObject, CLLocationManagerDelegate {
//    
//    static let share = GetUserLocationViewController()
//    
//    let locationManager = CLLocationManager()
//
//    var placeMark: CLPlacemark?
//    
//    lazy var userCity = String()
//    lazy var userCountry = String()
//    lazy var isLocationUpdated: Bool = false
//    
//    override init() {
//        super.init()
//        
//        locationManager.delegate = self
//            // Request authorization only if the status is not determined
//            if CLLocationManager.authorizationStatus() == .notDetermined {
//                locationManager.requestWhenInUseAuthorization()
//            }
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        
//    }
//    
//    func getLocation() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            if CLLocationManager.authorizationStatus() == .notDetermined {
//                self.locationManager.requestWhenInUseAuthorization()
//            }
//        }
//    }
//    
//    // didUpdateLocations
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location: CLLocation = manager.location else { return }
//        
//        locationManager.stopUpdatingLocation()
//        // Use [weak self] to prevent strong reference cycles
//        fetchCityAndCountry(from: location) { [weak self] city, country, postalCode, subLocality, error in
//            guard let self = self else { return }
//            
//            guard let city = city, let country = country, let postalCode = postalCode, let subLocality = subLocality, error == nil else { return }
//            
//            print(city + ", " + country)
//            print(postalCode)
//            print(subLocality)
//            print(location.coordinate.latitude)
//            print(location.coordinate.longitude)
//            
//            userCity = city
//            userCountry = country
//            UserDefaults.standard.set(city, forKey: "location")
//            print(UserDefaults.standard.string(forKey: "location") ?? "")
//            print("The latitude of the user is: \(location.coordinate.latitude)")
//            print("The longitude of the user is: \(location.coordinate.longitude)")
//            
//            if (isLocationUpdated == false) {
//                print("Abhi location update nhi hui hai. ab update krni hai.")
//                sendLocation(country: userCountry, city: userCity, lat: location.coordinate.latitude, lng: location.coordinate.longitude)
//            } else {
//                print("Location update ho chuki hai. ab update ni krni hai.")
//            }
//        }
//        
//        
//        
//    }
//
//    
//    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ postalCode: String?, _ subLocality: String? , _ country:  String?, _ error: Error?) -> ()) {
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            completion(placemarks?.first?.locality,
//                       placemarks?.first?.country,
//                       placemarks?.first?.postalCode,
//                       placemarks?.first?.subLocality,
//                       error)
//        }
//    }
//    
//    // didFailWithError
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("location error：\(error.localizedDescription)")
//    }
//}
//
//extension GetUserLocationViewController {
//    
//    func sendLocation(country:String,city:String,lat:Double,lng:Double) {
//       
//        let url = "https://zeep.live/api/update-lat-lng?country=\(country)&user_city=\(city)&lat=\(lat)&lng=\(lng)"
//        print(url)
//        
//        ApiWrapper.sharedManager().sendUserLocation(url: url) { [weak self] (value) -> Void in
//            guard let self = self else { return }
//            
//            print(value)
//            isLocationUpdated = true
//            
//        }
//    }
//}
