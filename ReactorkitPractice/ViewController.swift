//
//  ViewController.swift
//  ReactorkitPractice
//
//  Created by Euijoon Jung on 2021/12/20.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, View {
    
    typealias Reactor = MainReactor
    var disposeBag: DisposeBag = DisposeBag()
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var loginProgressingLabel: UILabel!
    @IBOutlet weak var loginResultLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        self.reactor = MainReactor()
    }
    
    private func setupUI() {
        idTextField.delegate = self
        pwTextField.delegate = self
    }
    
    func bind(reactor: MainReactor) {
        idTextField.rx.text
            .map { Reactor.Action.updateId($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text
            .map { Reactor.Action.upatePw($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .map { Reactor.Action.login(self.idTextField.text, self.pwTextField.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isProgressable }
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        

        reactor.state

            .observe(on: MainScheduler.instance)
            .map({ state -> Reactor.State in
                
                print("loginProgressing : \(state.isLoginProgressing)")
                return state
            })
            .map({ state in
                return !state.isLoginProgressing
            })
            .bind(to: loginProgressingLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map({ !$0.isLoginFinished})
            .bind(to: loginResultLabel.rx.isHidden)
            .disposed(by: disposeBag)
    
            
        reactor.state
            .map({ $0.isAccpeted })
            .map({ $0 ? "로그인 완료" : "로그인 실패"})
            .bind(to: loginResultLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    
}



extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
