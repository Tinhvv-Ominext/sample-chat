//
//  RCFileLoader.swift
//  app
//
//  Created by tinhvv-ominext on 7/3/20.
//  Copyright © 2020 KZ. All rights reserved.
//

import Foundation
import UIKit

//-------------------------------------------------------------------------------------------------------------------------------------------------
class RCFileLoader: NSObject {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    class func start(_ rcmessage: RCMessage, in tableView: UITableView, at: IndexPath) {

        if let path = MediaDownload.pathFile(rcmessage.messageId, ext: rcmessage.fileExt) {
            showMedia(rcmessage, path: path)
        } else {
            loadMedia(rcmessage, in: tableView, at: at)
        }
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    class func manual(_ rcmessage: RCMessage, in tableView: UITableView, at: IndexPath) {

        MediaDownload.clearManualAudio(rcmessage.messageId)
        downloadMedia(rcmessage, in: tableView, at: at)
        tableView.reloadRows(at: [at], with: .none)
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    private class func loadMedia(_ rcmessage: RCMessage, in tableView: UITableView, at: IndexPath) {

        let network = Persons.networkAudio()

        if (network == NETWORK_MANUAL) || ((network == NETWORK_WIFI) && (Connectivity.isReachableViaWiFi() == false)) {
            rcmessage.mediaStatus = MEDIASTATUS_MANUAL
        } else {
            downloadMedia(rcmessage, in: tableView, at: at)
        }
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    private class func downloadMedia(_ rcmessage: RCMessage, in tableView: UITableView, at: IndexPath) {

        rcmessage.mediaStatus = MEDIASTATUS_LOADING

        MediaDownload.startFile(rcmessage.messageId, ext: rcmessage.fileExt, progress: { (percent) in
            if let cell = tableView.cellForRow(at: at) as? RCMessageFileCell {
                cell.updateProgress(percent)
            }
        }, completion: { (path, error) in
            if (error == nil) {
                Cryptor.decrypt(path: path, chatId: rcmessage.chatId)
                showMedia(rcmessage, path: path)
            } else {
                rcmessage.mediaStatus = MEDIASTATUS_MANUAL
            }
            tableView.reloadRows(at: [at], with: .none)
        })
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    private class func showMedia(_ rcmessage: RCMessage, path: String) {

        rcmessage.filePath = path
        rcmessage.mediaStatus = MEDIASTATUS_SUCCEED
    }
}
