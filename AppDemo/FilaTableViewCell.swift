//
//  FilaTableViewCell.swift
//  AppDemo
//
//  Created by STI on 05/12/16.
//  Copyright © 2016 integrait. All rights reserved.
//

import UIKit

class FilaTableViewCell: UITableViewCell {

    @IBOutlet weak var lblIzquierda: UILabel!
    @IBOutlet weak var lblDerecha: UILabel!
    @IBOutlet weak var imfFila: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }

}
