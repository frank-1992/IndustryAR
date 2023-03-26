//
//  Localizable.swift
//  IndustryAR
//
//  Created by 吴熠 on 3/1/23.
//

import UIKit

let project = "project"
let history = "history"
let mine = "mine"

let drawing = "drawing"
let triangle = "triangle"
let square = "square"
let circle = "circle"
let text_local = "text"
let insert_occlusion = "insert_occlusion"
let remove_occlusion = "remove_occlusion"
let background_photography = "background_photography"
let delete_background_photography = "delete_background_photography"
let delete_local = "delete"
let setting_local = "setting"
let marker_local = "marker"
let none_marker_local = "none_marker"

let enter_text = "enter_text"
let cancel = "cancel"
let confirm = "confirm"

let line_color = "line_color"
let line_thickness = "line_thickness"
let line_type = "line_type"
let marker_size = "marker_size"
let text_color = "text_color"
let text_size = "text_size"
let text_font = "text_font"
let move_background = "move_background"

let normal_line = "normal_line"
let dash_line = "dash_line"

let save_success = "save_success"
let save_fail = "save_fail"
let save_error = "save_error"

let save_window_tip = "save_window_tip"

let save = "save"

let save_cover_tip = "save_cover_tip"

let download_url = "download_url"
let download = "download"

extension String {
    func localizedString() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
