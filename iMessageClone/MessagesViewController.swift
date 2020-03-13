//
//  MessagesViewController.swift
//  iMessageClone
//
//  Created by Bahadir Oncel on 03/03/2020.
//  Copyright © 2020 Stream.io. All rights reserved.
//

import UIKit
import StreamChat
import RxSwift

class MessagesViewController: ChatViewController {
    
    private let cameraButton = UIButton()
    private let soundRecordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        setupNavigationBar()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.setImage(UIImage(systemName: "camera.fill",
                                      withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))),
                              for: .normal)
        cameraButton.tintColor = UIColor.gray.withAlphaComponent(0.7)
        
        view.addSubview(soundRecordButton)
        soundRecordButton.translatesAutoresizingMaskIntoConstraints = false
        soundRecordButton.setImage(UIImage(systemName: "waveform.circle.fill",
                                           withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .bold))),
                              for: .normal)
        soundRecordButton.tintColor = UIColor.gray.withAlphaComponent(0.7)
        
        NSLayoutConstraint.activate([
            cameraButton.centerYAnchor.constraint(equalTo: composerView.centerYAnchor),
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            cameraButton.heightAnchor.constraint(equalToConstant: 40),
            
            soundRecordButton.centerYAnchor.constraint(equalTo: composerView.centerYAnchor),
            soundRecordButton.rightAnchor.constraint(equalTo: composerView.rightAnchor, constant: -2),
        ])
        
        composerView
            .sendButtonVisibility
            .asDriver(onErrorJustReturn: (isHidden: false, isEnabled: false))
            .drive(onNext: { [weak self] state in
                self?.soundRecordButton.isHidden = !state.isHidden
            }).disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        guard let channel = presenter?.channel else {
            return
        }
        
        navigationItem.rightBarButtonItem = nil
        
        let chatNavigationTitleView = ChatNavigationTitleView()
        chatNavigationTitleView.update(title: channel.name ?? "", imageURL: channel.imageURL)
        navigationItem.titleView = chatNavigationTitleView
    }
}

class ChatNavigationTitleView: UIView {
    private let avatar = AvatarView(cornerRadius: 12)
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 12)
        
        NSLayoutConstraint.activate([
            avatar.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatar.topAnchor.constraint(equalTo: topAnchor),
            avatar.leftAnchor.constraint(equalTo: leftAnchor),
            avatar.rightAnchor.constraint(equalTo: rightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func update(title: String, imageURL: URL?) {
        titleLabel.text = title
        titleLabel.sizeToFit()
        avatar.update(with: imageURL, name: title, baseColor: .clear)
    }
}
