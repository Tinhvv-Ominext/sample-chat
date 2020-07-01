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

        textView.textColor = rcmessage.incoming ? RCDefaults.textTextColorIncoming : RCDefaults.textTextColorOutgoing

        textView.text = rcmessage.fileNameFull
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func layoutSubviews() {

        let size = RCMessageTextCell.size(messagesView, at: indexPath)

        super.layoutSubviews(size)

        textView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
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

        let rect = rcmessage.text.boundingRect(with: CGSize(width: maxwidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: RCDefaults.textFont], context: nil)

        let width = rect.size.width + RCDefaults.textInsetLeft + RCDefaults.textInsetRight
        let height = rect.size.height + RCDefaults.textInsetTop + RCDefaults.textInsetBottom

        return CGSize(width: CGFloat.maximum(width, RCDefaults.textBubbleWidthMin), height: CGFloat.maximum(height, RCDefaults.textBubbleHeightMin))
    }
}
