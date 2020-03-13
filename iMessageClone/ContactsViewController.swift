//
//  ContactsViewController.swift
//  iMessageClone
//
//  Created by Bahadir Oncel on 28.01.2020.
//  Copyright © 2020 Stream.io. All rights reserved.
//

import UIKit
import StreamChat
import StreamChatCore

class ContactsViewController: ChannelsViewController {
    
    override func viewDidLoad() {
        presenter = ChannelsPresenter(filter: .currentUserInMembers)
        
        title = "Messages"
        
        setupStyles()
        tableView.register(ContactListCell.self, forCellReuseIdentifier: ContactListCell.reuseIdentifier)
        tableView.tableFooterView = nil
        
        navigationItem.largeTitleDisplayMode = .always
        
        deleteChannelBySwipe = true
        
        super.viewDidLoad()
    }
    
    override func updateChannelCell(_ cell: ChannelTableViewCell, channelPresenter: ChannelPresenter) {
        super.updateChannelCell(cell, channelPresenter: channelPresenter)
        
        if let cell = cell as? ContactListCell {
            cell.isUnread = channelPresenter.isUnread
        }
    }
    
    override func createChatViewController(with channelPresenter: ChannelPresenter) -> ChatViewController {
        MessagesViewController(nibName: nil, bundle: nil)
    }
    
    private func setupStyles() {
        view.directionalLayoutMargins.leading = 24
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = view.layoutMargins.left - 16
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        style.channel.nameFont = .boldSystemFont(ofSize: 16)
        style.channel.nameColor = .black
        
        style.channel.nameUnreadFont = .boldSystemFont(ofSize: 16)
        style.channel.nameUnreadColor = .black
        
        style.channel.messageFont = .systemFont(ofSize: 15)
        style.channel.messageColor = .gray
        style.channel.messageNumberOfLines = 2
        
        style.channel.messageUnreadFont = .systemFont(ofSize: 15)
        style.channel.messageUnreadColor = .gray
        style.channel.messageNumberOfLines = 2
        
        style.channel.dateFont = .systemFont(ofSize: 15)
        style.channel.dateColor = .gray
        
        style.channel.verticalTextAlignment = .top
        
        let separatorStyle = SeparatorStyle(color: UIColor.lightGray.withAlphaComponent(0.6),
                                            inset: UIEdgeInsets(top: 0, left: view.layoutMargins.left, bottom: 0, right: 0),
                                            tableStyle: .singleLine)
        style.channel.separatorStyle = separatorStyle
        
        style.channel.spacing.vertical = 2
        style.channel.spacing.horizontal = 16
        
        style.channel.avatarViewStyle?.verticalAlignment = .center
        style.channel.avatarViewStyle?.radius = 46 / 2
        
        style.channel.height = 46 + 16 * 2
        
        style.channel.edgeInsets.top = 8
        style.channel.edgeInsets.bottom = 8
        style.channel.edgeInsets.left = view.layoutMargins.left
        style.channel.edgeInsets.right = view.layoutMargins.right + 16 * 2
        
        // Chat screen styling
        
        style.incomingMessage.avatarViewStyle = nil
        style.incomingMessage.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 235/255, alpha: 1)
        style.incomingMessage.borderColor = .clear
        style.incomingMessage.textColor = .black
        style.incomingMessage.font = .systemFont(ofSize: 17, weight: .regular)
        style.incomingMessage.edgeInsets.left = 16
        style.incomingMessage.infoFont = .systemFont(ofSize: 0)
        style.incomingMessage.nameFont = .systemFont(ofSize: 0)

        style.outgoingMessage.avatarViewStyle = nil
        style.outgoingMessage.backgroundColor = UIColor(red: 35/255, green: 126/255, blue: 254/255, alpha: 1)
        style.outgoingMessage.borderColor = .clear
        style.outgoingMessage.textColor = .white
        style.outgoingMessage.font = .systemFont(ofSize: 17, weight: .regular)
        style.outgoingMessage.edgeInsets.right = 16
        style.outgoingMessage.infoFont = .systemFont(ofSize: 0)

        style.composer.backgroundColor = .white
        style.composer.placeholderTextColor = UIColor.gray.withAlphaComponent(0.5)
        style.composer.placeholderText = "iMessage"
        style.composer.height = 40
        style.composer.font = .systemFont(ofSize: 18)
        style.composer.cornerRadius = style.composer.height / 2
        let borderColor = UIColor.gray.withAlphaComponent(0.6)
        let borderWidth: CGFloat = 1
        style.composer.states = [.active: .init(tintColor: borderColor, borderWidth: borderWidth),
                                 .edit: .init(tintColor: borderColor, borderWidth: borderWidth),
                                 .disabled: .init(tintColor: borderColor, borderWidth: borderWidth),
                                 .normal: .init(tintColor: borderColor, borderWidth: borderWidth)]
        style.composer.edgeInsets.left = 60
        style.composer.edgeInsets.right = 16
    }
}
