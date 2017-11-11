

import UIKit

protocol MessageDetailMapViewDelegate: class {
    func detailsRequestedForMessage(message: Message)
}

class MessageDetailMapView: UIView {
    // outlets
    
    @IBOutlet var backgroundContentButton: UIButton!
    @IBOutlet var messageDate: UILabel!
    @IBOutlet var messageFilter: UILabel!
    @IBOutlet var content: UILabel!
    @IBOutlet var bookmarkButton: UIButton!
    // data
    var message: Message!
    weak var delegate: MessageDetailMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // appearance
        backgroundContentButton.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down)
    }
    
    func configureWithMessage(message: Message) {
        self.message = message
        
        content.text = message.content
    }
    
    // MARK: - UITableViewDelegate/DataSource methods
    
    // MARK: - Hit test. We need to override this to detect hits in our custom callout.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.

        // details button
        if let result = bookmarkButton.hitTest(convert(point, to: bookmarkButton), with: event) {
            return result
        }
        // fallback to our background content view
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
 
}
