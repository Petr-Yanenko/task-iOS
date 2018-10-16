//
//  Constants.swift
//  task iOS
//
//  Created by petr on 10/12/18.
//  Copyright © 2018 petr. All rights reserved.
//

import Foundation

let kBaseURLString: String = "https://cua-users.herokuapp.com/";

let kUserRequestKeyPath: String = "users.php";

let kNavigationBarFont = UIFont(name:"HelveticaNeue-Light", size:17.0);
    
let kMainBackgroundColor = UIColor.darkGray;
        
let kMainTintColor = UIColor.white;
            
let kMainTextColor = UIColor.white;

enum TIOSError: Error {
    case GenericError(Error?);
    case TaskException(NSError);
    case RequestInitError;
    case RelativeURLError;
    case URLRequestError(Error);
    case PercentEncodingError;
    case InvalidResponseError(Error?);
    case JSONError(Error);
    case HTTPError(Int, Any?);
    case UsersMappingError;
    case ActivityIndicatorCounterError;
    case CreatingUserRequestInitError;
    
    var localizedFailureReason: String {
        get {
            switch self {
            case .GenericError(let error):
                return self._createErrorDescription(message: "Unknown error", underlyingError: error);
            case .TaskException(let error):
                return self._createErrorDescription(message: "Unhandled exception", underlyingError: error);
            case .RequestInitError:
                return "JSON object is invalid";
            case .RelativeURLError:
                return "Url not created";
            case .URLRequestError(let error):
                return self._createErrorDescription(message: "Request not created", underlyingError: error);
            case .PercentEncodingError:
                return "Cannot add percent encoding";
            case .InvalidResponseError(let error):
                return self._createErrorDescription(message: "Invalid Response", underlyingError: error);
            case .JSONError(let error):
                return self._createErrorDescription(message: "JSON Error", underlyingError: error);
            case .HTTPError(let code, let object):
                let message = "HTTP error \(code), \(object ?? "no description")";
                return message;
            case .UsersMappingError:
                return "Cannot map users data";
            case .ActivityIndicatorCounterError:
                return "Invalid counter discovered";
            case .CreatingUserRequestInitError:
                return "User is nil";
            }
        }
    }
    
    private func _createErrorDescription(message: String, underlyingError: Error?) -> String {
        
        if let error = underlyingError {
            return message + error.localizedDescription;
        }
        
        return message;
    }
    
}
