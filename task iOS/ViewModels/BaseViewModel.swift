//
// Created by Petr Yanenko on 8/18/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

private var _newDataContext: UInt8 = 0;
private var _loadingContext: UInt8 = 0;
private var _errorContext: UInt8 = 0;

@objc protocol PViewModel : Model {
    
    var errorTitle : String? { get };
    var errorMessage : String? { get };
    
}

class BaseViewModel : NSObject, PViewModel {
    
    dynamic var newData: Bool = false;
    
    dynamic var loading: Bool = false;
    
    dynamic var error: Error? {
        didSet {
            if let unwrapped = error {
                ErrorHandler.instance.reportError(withError: unwrapped);
            }
        }
    };

    var _model: BaseModel;
    
    var _data: Any;

    var _errorTitle: String?;
    var errorTitle: String? { get { return _errorTitle; } }
    
    var _errorMessage: String?;
    var errorMessage: String? { get { return _errorMessage; } }
    

    deinit {
        self.sna_unregisterAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.newData),
            context:&_newDataContext
        );
        self.sna_unregisterAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.loading),
            context:&_loadingContext
        );
        self.sna_unregisterAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.error),
            context:&_errorContext
        );
        NotificationCenter.default.removeObserver(self);
    }

    init(model: BaseModel, data: Any) {
        //First stage of initialization
        _model = model;
        _data = data;
        
        super.init();
        //Second stage of initialization
        
        self._addObservers(model);
    }

    func reset() {
        self._model.reset();
    }

    func loadData() {
        self._model.loadData();
    }

    func cancel() {
        self._model.cancel();
    }
    
    func reload() {
        self.reset();
        self.loadData();
    }
    
    func suspend() {
        self._model.suspend();
    }
    
    func resume() {
        self._model.resume();
    }
    
}

// MARK: protected
@objc extension BaseViewModel {
    
    func _createViewData() throws -> Any {
        throw TIOSError.GenericError(nil);
    }
    
    func _addObservers(_ model : BaseModel) -> Void {
        self.sna_registerAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.loading),
            context:&_loadingContext
        ) { [weak self] subject, old, new in
            if let sself = self {
                let loading = sself._model.loading;
                sself.loading = loading;
                if loading {
                    ActivityIndicatorController.instance.incrementActivityIndicator();
                }
                else {
                    ActivityIndicatorController.instance.decrementActivityIndicator();
                }
            }
        }
        self.sna_registerAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.error),
            context:&_errorContext
        ) { [weak self] subject, old, new in
            if let sself = self {
                let error = sself._model.error;
                sself._sendError(error);
            }
        }
        self.sna_registerAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.newData),
            context:&_newDataContext
        ) { [weak self] subject, old, new in
            if let sself = self {
                sself._setData();
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_handleWillResignActiveNotification(_:)),
            name: Notification.Name.UIApplicationWillResignActive,
            object: nil
        );
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_handleDidBecomeActiveNotification(_:)),
            name: Notification.Name.UIApplicationDidBecomeActive,
            object: nil
        );
    }
    
    func _setData() {
        do {
            let data = try self._createViewData();
            self._setData(data);
        }
        catch {
            self._sendError(error);
        }
    }
    
    func _setData(_ data: Any) {
        self._data = data;
        self.newData = true;
    }
    
    func _sendError(_ error: Error?) {
        _errorTitle = self._createErrorTitle(from: error);
        _errorMessage = self._createErrorMessage(from: error);
        self.error = error;
    }
    
    func _createErrorTitle(from error: Error?) -> String {
        return "Error";
    }
    
    func _createErrorMessage(from error: Error?) -> String {
        return self._tiosError(from: error)?.localizedFailureReason ?? "No Description";
    }
    
    @nonobjc final func _tiosError(from: Error?) -> TIOSError? {
        return error as? TIOSError;
    }
    
}

// MARK: Notifications
@objc extension BaseViewModel {
    
    func _handleWillResignActiveNotification(_ notification: Notification) {
        self.suspend();
    }
    
    func _handleDidBecomeActiveNotification(_ notification: Notification) {
        self.resume();
    }
    
}
