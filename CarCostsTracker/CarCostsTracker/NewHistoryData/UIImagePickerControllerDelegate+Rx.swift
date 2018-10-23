//
//  UIImagePickerControllerDelegate+Rx.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 19/10/2018.
//  Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

//Creating extension for base where is our ImagePickerController object
extension Reactive where Base == UIImagePickerController {
    
    //creating deligate proxy from UIImagePickerControllerDelegateProxy
    internal var pickerDelegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate> {
        return UIImagePickerControllerDelegateProxy.proxy(for: base)
    }
    
    //Simple check that our delegate proxy is correct type and retriving this proxy object
    private var castDelegate: UIImagePickerControllerDelegateProxy {
        guard let delegate = pickerDelegate as? UIImagePickerControllerDelegateProxy else  {
            fatalError("Failed to cast delegate for UIImagePickerControllerDelegate & UINavigationControllerDelegate")
        }
        return delegate
    }
    
    //setting Obbservable of picked image so we can call it as rx.pickedImage, and will recive this Observable from proxy.
    public var pickedImage: Observable<UIImage>{
        return castDelegate.didSelectImage
    }
}


extension UIImagePickerController: HasDelegate{
    public typealias Delegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate
    //typelias is a shortener for long types like UIImagePickerControllerDelegate & UINavigationControllerDelegate
}


final class UIImagePickerControllerDelegateProxy: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DelegateProxyType {
    
    //Retriving delegate field from UIImagePickerController
    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }
    
    //Setting delegate that is created by proxy to object delegate field
    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
    
    public weak private(set) var picker: UIImagePickerController?
    
    //Initializing our picker with delegateProxy
    public init(picker: UIImagePickerController) {
        self.picker = picker
        super.init(parentObject: picker, delegateProxy: UIImagePickerControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { UIImagePickerControllerDelegateProxy(picker: $0) }
    }
    
    private var didSelectImageSink = PublishSubject<UIImage>()
    
    public var didSelectImage: Observable<UIImage> {
        return didSelectImageSink.asObservable()
    }
    
    //Func that called by picker it self when imgae is picked.
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            didSelectImageSink.onError("Expected a dictionary containing an image, but was provided the following: \(info)")
            return
        }
        didSelectImageSink.onNext(selectedImage)
    }
    
    deinit {
        didSelectImageSink.onCompleted()
    }
}

