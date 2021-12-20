//
//  LoginService.swift
//  ReactorkitPractice
//
//  Created by Euijoon Jung on 2021/12/20.
//

import Foundation
import RxSwift
class LoginService {
    
    fileprivate static let id: String = "1234@1234"
    fileprivate static let pw: String = "12341234"
    
    static func checkAvailibility(_ id: String, _ pw: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            
            
            if LoginService.id == id &&
                LoginService.pw == pw {
                observer.onNext(true)
            } else {
                observer.onNext(false)
            }
                
            observer.onCompleted()
            
            return Disposables.create()
        }
    }

}
