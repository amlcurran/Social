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
    
    let dateFormatter = NSDateFormatter();

    let dayColor = UIColor.blackColor().colorWithAlphaComponent(0.54);
    @IBOutlet weak var `internal`: UIView!
    
    

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
//        self.`internal`.layer.borderWidth = 2;
//        self.`internal`.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.10).CGColor;
//        self.`internal`.layer.cornerRadius = 8;
//        
        if (slot != nil && slot!.count() > 1) {
            numberLabel.text = String(format: "+%lu", slot!.count() - 1);
            numberLabel.hidden = false;
        } else {
            numberLabel.hidden = true;
        }
    }
    
}