//
//  RCMessageFileCell.swift
//  app
//
//  Created by tinhvv-ominext on 7/1/20.
//  Copyright © 2020 KZ. All rights reserved.
//

import Foundation
import UIKit

class RCMessageFileCell: RCMessageCell {

    private var icon: UIImageView!
    private var textView: UITextView!
    private var sizeLabel: UILabel!
    private var button: UIButton!
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func bindData(_ messagesView: RCMessagesView, at indexPath: IndexPath) {

        super.bindData(messagesView, at: indexPath)

        let rcmessage = messagesView.rcmessageAt(indexPath)

        viewBubble.backgroundColor = rcmessage.incoming ? RCDefaults.textBubbleColorIncoming : RCDefaults.textBubbleColorOutgoing

        if (textView == nil) {
            textView = UITextView()
            textView.font = RCDefaults.textFont
            textView.isEditable = false
            textView.isSelectable = false
            textView.isScrollEnabled = false
            textView.isUserInteractionEnabled = false
            textView.backgroundColor = UIColor.clear
            textView.textContainer.lineFragmentPadding = 0
            textView.textContainerInset = RCDefaults.textInset
            viewBubble.addSubview(textView)
        }
        
        if sizeLabel == nil {
            sizeLabel = UILabel()
            sizeLabel.font = RCDefaults.subTextFont
            viewBubble.addSubview(sizeLabel)
        }
        
        if icon == nil {
            icon = UIImageView(image: UIImage(named: "callvideo_hangup"))
            viewBubble.addSubview(icon)
        }
        
        if button == nil {
            button = UIButton()
            button.setImage(UIImage(named: "callvideo_answer"), for: .normal)
            viewBubble.addSubview(button)
        }

        textView.textColor = rcmessage.incoming ? RCDefaults.textTextColorIncoming : RCDefaults.textTextColorOutgoing
        sizeLabel.textColor = textView.textColor

        textView.text = rcmessage.fileName
        sizeLabel.text = rcmessage.fileSizeFull
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func layoutSubviews() {

        let size = RCMessageFileCell.size(messagesView, at: indexPath)

        super.layoutSubviews(size)
        icon.frame = CGRect(x: RCDefaults.commonMargin, y: RCDefaults.commonMargin, width: RCDefaults.iconSize, height: RCDefaults.iconSize)
        textView.frame = CGRect(x: icon.frame.origin.x + icon.frame.width, y: 0, width: size.width - RCDefaults.iconSize - RCDefaults.downloadButtonSize - RCDefaults.commonMargin, height: size.height - RCDefaults.headerLowerHeight)
        sizeLabel.frame = CGRect(x: icon.frame.origin.x + icon.frame.width + RCDefaults.textInsetLeft, y: textView.frame.size.height - RCDefaults.textInsetBottom, width: textView.frame.width, height: RCDefaults.headerLowerHeight)
        
        button.frame = CGRect(x: textView.frame.origin.x + textView.frame.width - RCDefaults.commonMargin, y: (size.height - RCDefaults.downloadButtonSize) / 2, width: RCDefaults.downloadButtonSize, height: RCDefaults.downloadButtonSize)
    }

    // MARK: - Size methods
    //---------------------------------------------------------------------------------------------------------------------------------------------
    class func height(_ messagesView: RCMessagesView, at indexPath: IndexPath) -> CGFloat {

        let size = self.size(messagesView, at: indexPath)
        return size.height
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    class func size(_ messagesView: RCMessagesView, at indexPath: IndexPath) -> CGSize {

        let rcmessage = messagesView.rcmessageAt(indexPath)

        let widthTable = messagesView.tableView.frame.size.width

        let maxwidth = (0.6 * widthTable) - RCDefaults.textInsetLeft - RCDefaults.textInsetRight

        let rect = rcmessage.fileName.boundingRect(with: CGSize(width: maxwidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: RCDefaults.textFont], context: nil)

        let width = RCDefaults.iconSize + RCDefaults.commonMargin * 2 + rect.size.width + RCDefaults.textInsetLeft + RCDefaults.textInsetRight + RCDefaults.downloadButtonSize
        let height = rect.size.height + RCDefaults.textInsetTop + RCDefaults.textInsetBottom + RCDefaults.headerLowerHeight

        return CGSize(width: CGFloat.maximum(width, RCDefaults.textBubbleWidthMin), height: CGFloat.maximum(height, RCDefaults.textBubbleHeightMin))
    }
}
