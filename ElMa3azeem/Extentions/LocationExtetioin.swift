//
//  LocationExtetioin.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 16/11/2022.
//

import Foundation
import Alamofire
 
import CoreLocation

func getAddressFromLatLon(withLatitude: String, withLongitude: String , completion : @escaping (String?, Error?) -> ()){
    var geocoder = CLGeocoder()
    print("-> Finding user address...")
    
    var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
    let lat: Double = Double("\(withLatitude)") ?? 0.0
    let lon: Double = Double("\(withLongitude)") ?? 0.0
    center.latitude = lat
    center.longitude = lon
    
    let location: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
    
    geocoder.reverseGeocodeLocation(location,
                                    preferredLocale: Locale.init(identifier: Language.isArabic() ? "ar" : "en"),
                                    completionHandler: {(placemarks, error)->Void in
        var placemark:CLPlacemark!
        var addressString : String = ""

        if error == nil && placemarks?.count ?? 0 > 0 {
            placemark = placemarks![0] as CLPlacemark
            
            
            if placemark.isoCountryCode == "TW" /*Address Format in Chinese*/ {
                if placemark.country != nil {
                    addressString = placemark.country ?? ""
                }
                if placemark.subAdministrativeArea != nil {
                    addressString = addressString + (placemark.subAdministrativeArea ?? "") + " , "
                }
                if placemark.postalCode != nil {
                    addressString = addressString + (placemark.postalCode ?? "") + " "
                }
                if placemark.locality != nil {
                    addressString = addressString + (placemark.locality ?? "")
                }
                if placemark.thoroughfare != nil {
                    addressString = addressString + (placemark.thoroughfare ?? "")
                }
                if placemark.subThoroughfare != nil {
                    addressString = addressString + (placemark.subThoroughfare ?? "")
                }
            } else {

                if placemark.thoroughfare != nil {
                    addressString = addressString + (placemark.thoroughfare ?? "") + " , "
                }
                if placemark.locality != nil {
                    addressString = addressString + (placemark.locality ?? "") + " , "
                }
                if placemark.administrativeArea != nil {
                    addressString = addressString + (placemark.administrativeArea ?? "") + " "
                }
                if placemark.country != nil {
                    addressString = addressString + (placemark.country ?? "")
                }
            }
            
            completion(addressString,nil)
            print(addressString)
        }
    })
}
