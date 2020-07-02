//
// Copyright (c) 2020 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

//-------------------------------------------------------------------------------------------------------------------------------------------------
class RCHeaderUpperCell: UITableViewCell {

	private var indexPath: IndexPath!
	private var messagesView: RCMessagesView!

	private var labelText: UILabel!
    private var separatorView: UIView!
    
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(_ messagesView: RCMessagesView, at indexPath: IndexPath) {

		self.indexPath = indexPath
		self.messagesView = messagesView

		backgroundColor = UIColor.clear
        
        if separatorView == nil {
            separatorView = UIView()
            separatorView.backgroundColor = .systemGroupedBackground
            contentView.addSubview(separatorView)
        }

		if (labelText == nil) {
			labelText = UILabel()
			labelText.font = RCDefaults.headerUpperFont
			labelText.textColor = RCDefaults.headerUpperColor
            labelText.backgroundColor = .white
			contentView.addSubview(labelText)
		}
        
        labelText.isHidden = messagesView.textHeaderUpper(indexPath) == nil
        separatorView.isHidden = labelText.isHidden
        
		labelText.textAlignment = .center
		labelText.text = messagesView.textHeaderUpper(indexPath)
        
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func layoutSubviews() {

		super.layoutSubviews()

		let widthTable = messagesView.tableView.frame.size.width

        if let rect = messagesView.textHeaderUpper(indexPath)?.boundingRect(with: CGSize(width: widthTable, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: RCDefaults.headerUpperFont], context: nil) {
            separatorView.frame = CGRect(x: RCDefaults.commonMargin, y: RCDefaults.headerUpperHeight / 2, width: widthTable - RCDefaults.commonMargin * 2, height: 1)
            labelText.frame = CGRect(x: (widthTable - rect.width) / 2 - RCDefaults.commonMargin, y: RCDefaults.commonMargin, width: rect.width + RCDefaults.commonMargin * 2, height: RCDefaults.headerUpperHeight - RCDefaults.commonMargin * 2)
        }
        
	}

	// MARK: - Size methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func height(_ messagesView: RCMessagesView, at indexPath: IndexPath) -> CGFloat {

		return (messagesView.textHeaderUpper(indexPath) != nil) ? RCDefaults.headerUpperHeight : 0
	}
}
