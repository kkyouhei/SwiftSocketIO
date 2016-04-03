//
//  ViewController.swift
//  ChatSample
//
//  Created by 狩野 恭平 on 2016/04/02.
//  Copyright © 2016年 狩野 恭平. All rights reserved.
//

import UIKit
import SocketIOClientSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let socket = SocketIOClient(socketURL: NSURL(string: "http://192.168.33.12:3000")!, options: [.Log(true), .ForcePolling(true)])
    var textField: UITextField! = nil
    let table: UITableView = UITableView()
    var chatlog: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.socket.on("connect") {data, ack in
            print("socket connected")
        }
        self.socket.on("disconnect") {data in
            print("socket disconnect")
        }
        self.socket.on("sendMessageToClient") {data, ack in
            // TableView更新処理
            if let msg = data[0]["value"] as? String {
                self.chatlog.append(msg)
                self.table.reloadData()
            }
        }
        self.socket.connect()
        
        // 送信ボタン
        let button: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.width/3, 50))
        button.layer.position = CGPoint(x: self.view.frame.width-self.view.frame.width/5, y: self.view.frame.height-40)
        button.layer.cornerRadius = 2.0
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.borderWidth = 1.0;
        button.setTitle("送信", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: #selector(self.buttonTouch(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        // チャットテキスト
        textField = UITextField(frame: CGRectMake(0, 0, self.view.frame.width/2, 50))
        textField.layer.position = CGPoint(x: self.view.frame.width/3, y: self.view.frame.height-40)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.layer.masksToBounds = true
        textField.placeholder = "チャットテキスト"
        self.view.addSubview(textField)
        
        // チャットログ
        table.frame = CGRectMake(0 , UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.width, self.view.frame.height-120)
        table.delegate = self
        table.dataSource = self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(table)
    }

    func buttonTouch(sender: UIButton){
        self.socket.emit("sendMessageToServer", textField.text!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatlog.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = self.chatlog[indexPath.row]
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

