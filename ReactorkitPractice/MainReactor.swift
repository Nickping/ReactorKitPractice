//
//  MainReactor.swift
//  ReactorkitPractice
//
//  Created by Euijoon Jung on 2021/12/20.
//

import Foundation
import ReactorKit

class MainReactor: Reactor {
    let initialState: State = State()
    
    
    enum Action {
        case updateId(String?)
        case upatePw(String?)
        case login(String?, String?)
    }
    
    struct State {
        var inputId: String?
        var inputPw: String?
        var isProgressable: Bool = false
        var isAccpeted: Bool = false
        var isLoginProgressing: Bool = false
        var isLoginFinished: Bool = false
    }
    
    enum Mutation {
        case setId(String?)
        case setPw(String?)
        case loginReslt(Bool)
        case isLoadingLogin
    }
    
    // mutation에 따라 기존 state를 바꾸고 새로운 state를 반환한다
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setId(let inputId):
            var newState = state
            newState.inputId = inputId
            if let id = newState.inputId, !id.isEmpty,
               let pw = newState.inputPw, !pw.isEmpty{
                newState.isProgressable = true
            } else {
                newState.isProgressable = false
            }
            return newState
        case .setPw(let pw):
            var newState = state
            newState.inputPw = pw
            if let id = newState.inputId, !id.isEmpty,
               let pw = newState.inputPw, !pw.isEmpty{
                newState.isProgressable = true
            } else {
                newState.isProgressable = false
            }
            return newState
            
        case .loginReslt(let result):
            var newState = state
            newState.isLoginProgressing = false
            newState.isAccpeted = result
            newState.isLoginFinished = true
            return newState
            
        case .isLoadingLogin:
            var newState = state
            newState.isLoginFinished = false
            newState.isLoginProgressing = true
            return newState
            
        }
    }
    
    
    // action에 따라 side-effect ( service 등을 통하는.. ) 를 실행.
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .updateId(let id):
            return Observable.just(Mutation.setId(id))
        case .upatePw(let pw):
            return Observable.just(Mutation.setPw(pw))
        case .login(let inputId, let inputPw):
            guard let id = inputId, let pw = inputPw else {
                return Observable.just(Mutation.loginReslt(false))
            }
            
            return Observable.concat([
                Observable.just(Mutation.isLoadingLogin),
                
                LoginService.checkAvailibility(id, pw).map({ Mutation.loginReslt($0)}).delay(.seconds(2), scheduler: MainScheduler.instance)
            ])
        }
    }
    }
