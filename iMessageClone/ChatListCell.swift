//
//  MessageListCell.swift
//  iMessageClone
//
//  Created by Bahadir Oncel on 29.01.2020.
//  Copyright © 2020 Stream.io. All rights reserved.
//

import UIKit
import StreamChat

class MessageListCell: ChannelTableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private let unreadView = UIView()
    private let dateAccessory = UIImageView()
    
    var isUnread: Bool {
        get {
            return !unreadView.isHidden
        }
        set {
            unreadView.isHidden = !newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        unreadView.backgroundColor = .systemBlue
        unreadView.layer.cornerRadius = 10 / 2
        unreadView.layer.masksToBounds = true
        unreadView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(unreadView)
        
        dateAccessory.image = UIImage(systemName: "chevron.right",
                                      withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14),
                                                                                     scale: .default))?.withRenderingMode(.alwaysTemplate)
        dateAccessory.tintColor = UIColor.gray.withAlphaComponent(0.6)
        dateAccessory.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateAccessory)
        
        NSLayoutConstraint.activate([
            unreadView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unreadView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            unreadView.heightAnchor.constraint(equalToConstant: 10),
            unreadView.widthAnchor.constraint(equalTo: unreadView.heightAnchor),
            
            dateAccessory.topAnchor.constraint(equalTo: contentView.topAnchor, constant: style.edgeInsets.top + 2),
            dateAccessory.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        ])
    }
    
    override func update(date: Date) {
        dateLabel.text = date.formatRelativeString()
    }
}

fileprivate extension Date {
    func formatRelativeString() -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        dateFormatter.doesRelativeDateFormatting = true

        if calendar.isDateInToday(self) {
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
        } else if calendar.isDateInYesterday(self){
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
        } else if calendar.compare(Date(), to: self, toGranularity: .weekOfYear) == .orderedSame {
            let weekday = calendar.dateComponents([.weekday], from: self).weekday ?? 0
            return dateFormatter.weekdaySymbols[weekday-1]
        } else {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
        }

        return dateFormatter.string(from: self)
    }
}
