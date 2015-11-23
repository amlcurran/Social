//
//  CalendarSourceViewCell.swift
//  whatson
//
//  Created by Alex on 23/10/2015.
//  Copyright © 2015 Alex Curran. All rights reserved.
//

import Foundation
import UIKit

class CalendarSourceViewCell : UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var marginConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainMarginConstraint: NSLayoutConstraint!
    
    let dateFormatter = NSDateFormatter();

    let dayColor = UIColor.blackColor().colorWithAlphaComponent(0.54);

    func bind(item : SCCalendarItem, slot : SCCalendarSlot?) {
        dateFormatter.dateFormat = "EEE";
        let startTime = NSDate(timeIntervalSince1970: NSTimeInterval(item.startTime().getMillis() / 1000));
        let formatted = String(format: "%@ - %@", dateFormatter.stringFromDate(startTime), item.title());
        let colouredString = NSMutableAttributedString(string: formatted);
        if (item.isEmpty()) {
            colouredString.addAttribute(NSForegroundColorAttributeName, value: dayColor, range: NSMakeRange(0, colouredString.length));
        } else {
            colouredString.addAttribute(NSForegroundColorAttributeName, value: dayColor, range: NSMakeRange(0, 3));
        }
        
//        self.bounds = CGRectInset(self.frame, 16, 16);
        mainLabel.attributedText = colouredString;
        self.layer.borderWidth = 2;
        self.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.10).CGColor;
        self.layer.cornerRadius = 8;
        
        if (slot != nil && slot!.count() > 1) {
            numberLabel.text = String(format: "+%lu", slot!.count() - 1);
            numberLabel.hidden = false;
            widthConstraint.active = true;
            marginConstraint.active = true;
            mainMarginConstraint.active = false;
        } else {
            numberLabel.hidden = true;
            widthConstraint.active = false;
            marginConstraint.active = false;
            mainMarginConstraint.active = true;
        }
    }
    
}