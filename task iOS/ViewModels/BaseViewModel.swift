//
// Created by Petr Yanenko on 8/18/16.
// Copyright (c) 2016 Petr Yanenko. All rights reserved.
//

import Foundation

typealias Action = () -> Void;

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

    var _model : BaseModel;

    var _errorTitle : String?;
    var errorTitle : String? { get { return _errorTitle; } }
    
    var _errorMessage : String?;
    var errorMessage : String? { get { return _errorMessage; } }
    

    deinit {
        _model.sna_unregisterAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.newData),
            context:&_newDataContext
        );
        _model.sna_unregisterAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.loading),
            context:&_loadingContext
        );
        _model.sna_unregisterAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.error),
            context:&_errorContext
        );
    }

    init(model: BaseModel) {
        //First stage of initialization
        _model = model;
        
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
}

// MARK: protected
@objc extension BaseViewModel {
    
    func _createViewData() throws -> Any {
        throw TIOSError.GenericError(nil);
    }
    
    func _addObservers(_ model : BaseModel) -> Void {
        self._model.sna_registerAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.loading),
            context:&_loadingContext
        ) { [weak self] subject, old, new in
            if let sself = self {
                let loading = sself._model.loading;
                sself.loading = loading;
            }
        }
        self._model.sna_registerAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.error),
            context:&_errorContext
        ) { [weak self] subject, old, new in
            if let sself = self {
                let error = sself._model.error;
                sself._sendError(error);
            }
        }
        self._model.sna_registerAsObserver(
            withSubject:_model,
            property:#selector(getter: BaseModel.newData),
            context:&_newDataContext
        ) { [weak self] subject, old, new in
            if let sself = self {
                sself._setData();
            }
        }
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
