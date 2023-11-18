//
//  LaunchViewController.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 08.11.2023.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController{
    //MARK: - propities
    private var progressTimer = Timer()
    private var timerState = 0
    private var loaderImage: UIImageView = {
        $0.image = UIImage(named: "Loading component")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rotate()
        return $0
    }(UIImageView())
    
    private var titleImage: UIImageView = {
        $0.image = UIImage(named: "titleLaunchScreen")
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLaunchViewController()
    }
    //MARK: - Methods
    
    private func createLaunchViewController(){
        view.backgroundColor = .white
        view.addSubview(loaderImage)
        view.addSubview(titleImage)
        createAnchor()
        createProgressTimer()
    }
    
    private func createProgressTimer() {
        progressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
    }
    
    @objc func timerMethod() {
        if timerState != 3{
            timerState += 1
        }else{
            loaderImage.layer.removeAllAnimations()
            progressTimer.invalidate()
            let viewController = TabBarController()
            viewController.selectedIndex = 0
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false)
        }
    }
    
    private func createAnchor() {
        NSLayoutConstraint.activate([
            loaderImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loaderImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            titleImage.bottomAnchor.constraint(equalTo: self.loaderImage.topAnchor),
            titleImage.heightAnchor.constraint(equalToConstant: 50),
            titleImage.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor,constant: -40),
            titleImage.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor,constant: 40)
        ])
    }
}
