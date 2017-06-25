//
//  ViewController.swift
//  tableView
//
//  Created by waterway on 2017/6/24.
//  Copyright © 2017年 waterway. All rights reserved.
//

import UIKit

class User: NSObject{
    var name: String?
    init(name: String){
        self.name = name
    }
}

class ChoiceUserViewController: UIViewController {
    var titleView = UIView(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:64))
    var confirmBtn = UIButton(frame: CGRect(x:UIScreen.main.bounds.width-44,y:20,width:44,height:44))
    var cancelBtn = UIButton(frame: CGRect(x:0,y:20,width:44,height:44))
    //给UITableView的数据源
    var items:[String] = ["阿理","阿狸","阿狸3","阿狸4","阿狸5","随意","承诺","邓州","驰骋","骤然","王者荣耀","王国","赵小明","单222","代表","冼夫人","赧过","杨过","毛阿","李敏","孔劲","鸡杜","范特","包豪","乔天","温至敏","余安世","庞子仁","祝明明","李妮"]
    //存储选中单元格的索引
    var selectedIndexs = [[Int]]()
    
    var tableView:UITableView?
    //用户对象数组
    var userArray: [User] = [User]()
    //section分组
    var sectionsArray: [[User]] = [[User]]()
    //索引数组
    var indexArray: [String] = [String]()
    // uitableView 索引搜索工具类
    var collation: UILocalizedIndexedCollation? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        self.cancelBtn.setTitle("取消", for: .normal)
        self.cancelBtn.setTitleColor(UIColor.white, for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        self.titleView.addSubview(self.cancelBtn)
        self.confirmBtn.setTitle("确定", for: .normal)
        self.confirmBtn.setTitleColor(UIColor.white, for: .normal)
        self.confirmBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        self.titleView.addSubview(self.confirmBtn)
        self.titleView.backgroundColor = UIColor.blue
        self.view.addSubview(self.titleView)
        
        //创建表视图
        self.tableView = UITableView(frame: CGRect(x:0,y:64,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height-64), style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        //配置section
        self.configureSection()
        self.view.addSubview(self.tableView!)
    }
    //配置section
    func configureSection(){
        //初始化用户数组
        for name in items{
            userArray.append(User(name: name))
        }
        //获得当前UILocalizedIndexedCollation对象并且引用赋给collation,A-Z的数据
        collation = UILocalizedIndexedCollation.current()
        //获得索引数和section标题数
        let sectionTitlesCount = collation!.sectionTitles.count
        //临时数据，存放section对应的userObjs数组数据
        var tempSectionsArray = [[User]]()
        for _ in 0..<sectionTitlesCount{
            let array = [User]()
            tempSectionsArray.append(array)
        }
        //将用户数据进行分类，存储到对应的sesion数组中
        for user in userArray {
            //根据timezone的localename，获得对应的的section number
            let sectionNumber = collation?.section(for: user, collationStringSelector: #selector(getter: User.name))
            //获得section的数组
            var sectionUsers = tempSectionsArray[sectionNumber!]
            //添加内容到section中
            sectionUsers.append(user)
            // swift 数组是值类型，要重新赋值
            tempSectionsArray[sectionNumber!] = sectionUsers
        }
        //排序，对每个已经分类的数组中的数据进行排序，如果仅仅只是分类的话可以不用这步
        for i in 0..<sectionTitlesCount {
            let usersArrayForSection = tempSectionsArray[i]
            //获得排序结果
            let sortedUsersArrayForSection = collation?.sortedArray(from: usersArrayForSection, collationStringSelector:  #selector(getter: User.name))
            //替换原来数组
            tempSectionsArray[i] = sortedUsersArrayForSection as! [User]
        }
        sectionsArray = tempSectionsArray
        for _ in 0..<sectionsArray.count{
            let indexes = [Int]()
            selectedIndexs.append(indexes)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //取消按钮
    func cancelBtnClick(_ button:UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    //确定按钮点击
    func btnClick(_ button:UIButton) {
        print("选中项的索引为：", selectedIndexs)
        print("选中项的值为：")
        /*for items in selectedIndexs {
            
            for item in items{
                print(item)

            }
        }*/
        for i in 0..<selectedIndexs.count{
            for index in selectedIndexs[i]{
                print(sectionsArray[i][index].name!)
            }
        }
    }

    
}

extension ChoiceUserViewController:UITableViewDataSource{
    //----UITableViewDataSource begin--------
    //设置一个分区
     func numberOfSections(in tableView: UITableView) -> Int {
        return (collation?.sectionTitles.count)!
    }
    //每个分区返回的Cell数
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsArray[section].count
    }
   
    
    //创建每个Cell显示的内容
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            //利用Cell
            let identify:String = "Cell"
            //同一形式的Cell重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath) as UITableViewCell            
            let userNameInSection = sectionsArray[indexPath.section]
            let user = userNameInSection[indexPath.row]
            cell.textLabel?.text = (user as AnyObject).name
            //判断是否选中（选中单元格尾部打勾）
            
            if selectedIndexs[indexPath.section].contains(indexPath.row) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
    }
    //设置section的Header
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let usersInSection = sectionsArray[section]
        guard (usersInSection as AnyObject).count > 0 else{
            return nil
        }
        if let headserString = collation?.sectionTitles[section] {
            if !indexArray.contains(headserString) {
                indexArray.append(headserString)
            }
            return headserString
        }
        return nil
    }
    //设置索引标题
     func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexArray
    }
    //关联搜索
     func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return (collation?.section(forSectionIndexTitle: index))!
    }

    //----UITableViewDataSource end--------
}
extension ChoiceUserViewController:UITableViewDelegate{
    //----UITableViewDelegate begin--------
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //判断该行原先是否选中
        if let index = selectedIndexs[indexPath.section].index(of: indexPath.row){
            selectedIndexs[indexPath.section].remove(at: index)//原来选中的取消选中
        }else{
            selectedIndexs[indexPath.section].append(indexPath.row) //原来没选中的就选中
        }
        
        //刷新该行
        self.tableView?.reloadRows(at: [indexPath], with: .automatic)
        
        
    }
    
    //----UITableViewDelegate end--------
}
