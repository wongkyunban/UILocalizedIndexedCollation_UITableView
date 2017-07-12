//
//  ViewController.swift
//  tableView
//
//  Created by waterway on 2017/6/24.
//  Copyright © 2017年 waterway. All rights reserved.
//UITableView创建中文索引

import UIKit

//创建一个用户类
class User: NSObject{
    var name: String?
    init(name: String){
        self.name = name
    }
}

class ChoiceUserViewController: UIViewController {
    //导航视图
    let navView = UIView(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:64))
    //确定按钮
    let confirmBtn = UIButton(frame: CGRect(x:UIScreen.main.bounds.width-44,y:20,width:44,height:44))
    //取消按钮
    var cancelBtn = UIButton(frame: CGRect(x:0,y:20,width:44,height:44))
    //测试数据
    var items:[String] = ["阿理","阿狸","阿狸3","阿狸4","阿狸5","随意","承诺","邓州","驰骋","骤然","王者荣耀","王国","赵小明","单222","代表","冼夫人","赧过","杨过","毛阿","李敏","孔劲","鸡杜","范特","包豪","乔天","温至敏","余安世","庞子仁","祝明明","李妮"]
    //选中索引数组
    var selectedIndexs = [[Int]]()
    //列表
    var tableView:UITableView?
    //用户对象数组
    var userArray: [User] = [User]()
    //section分组数据
    var sectionsArray: [[User]] = [[User]]()
    //UILocalizedIndexedCollation 用于对数据源的数据进行分组排序
    var collation: UILocalizedIndexedCollation? = nil
    //索引数组
    fileprivate lazy var indexArray : [String] = {
        let list:[String] = [
            "A", "B", "C", "D", "E", "F", "G",
            "H", "I", "J", "K", "L", "M", "N",
            "O", "P", "Q", "R", "S", "T",
            "U", "V", "W", "X", "Y", "Z"]
        
        return list
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationView()
        self.configureTableView()
        self.configureSection()
    }
    
    //设置列表视图
    func configureTableView(){
        //创建表视图
        self.tableView = UITableView(frame: CGRect(x:0,y:64,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height-64), style:.plain)
        //设置代理
        self.tableView!.delegate = self
        //设置数据源
        self.tableView!.dataSource = self
        //复用Cell
        self.tableView!.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        //索引点击时的背景颜色
        //self.tableView?.sectionIndexTrackingBackgroundColor = UIColor.red
        //将tableView添加到主视图
        self.view.addSubview(self.tableView!)

    }
    //设置导航栏视图
    func configureNavigationView(){
        //取消按钮
        self.cancelBtn.setTitle("取消", for: .normal)
        //设置按钮的字体颜色
        self.cancelBtn.setTitleColor(UIColor.white, for: .normal)
        //按钮点击事件
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        //将按钮加入导航视图
        self.navView.addSubview(self.cancelBtn)
        //确定按钮
        self.confirmBtn.setTitle("确定", for: .normal)
        //设置按钮的字体颜色
        self.confirmBtn.setTitleColor(UIColor.white, for: .normal)
        //按钮点击事件
        self.confirmBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        //将按钮加入导航视图
        self.navView.addSubview(self.confirmBtn)
        //设置导航视图的背景颜色
        self.navView.backgroundColor = UIColor.blue
        //将导航视图添加到主视图中
        self.view.addSubview(self.navView)

    }
    //配置section
    func configureSection(){
        //初始化用户数组
        for name in items{
            userArray.append(User(name: name))
        }
        //获得当前UILocalizedIndexedCollation对象并且引用赋给collation,A-Z的数据
        collation = UILocalizedIndexedCollation.current()
        //获得索引数
        let sectionTitlesCount = collation!.sectionTitles.count
        //临时的section分组数据
        var tempSectionsArray = [[User]]()
        //初始化tempSectionsArray数组元素,都为[User]()
        for _ in 0...sectionTitlesCount{
            let array = [User]()
            tempSectionsArray.append(array)
        }
        //对用户数据进行分组，存到临时数组tempSectionsArray中去
        for user in userArray {
            //获得用户名对应的section分组索引
            let sectionNumber = collation?.section(for: user, collationStringSelector: #selector(getter: User.name))
            //根据上一步获得的索引，在tempSectionsArray找到对应的数组
            var sectionUsers = tempSectionsArray[sectionNumber!]
            //将用户附加到上一步找到的数组中去
            sectionUsers.append(user)
            // swift 数组是值类型，要重新赋值
            tempSectionsArray[sectionNumber!] = sectionUsers
        }
        //对每个section分组数据中的数据进行排序，排序的数据才会比较好看哦
        for i in 0...sectionTitlesCount {
            let usersArrayForSection = tempSectionsArray[i]
            //获得排序结果
            let sortedUsersArrayForSection = collation?.sortedArray(from: usersArrayForSection, collationStringSelector:  #selector(getter: User.name))
            //替换原来数组
            tempSectionsArray[i] = sortedUsersArrayForSection as! [User]
        }
        //将分好组，排好序的section分组数据的临时tempSectionsArray赋给正式的sectionsArray，哈哈哈！！！
        sectionsArray = tempSectionsArray
        //在这里先初始好selectedIndexs数组，到时用来记录选择的数据
        for _ in 0..<sectionsArray.count{
            let indexes = [Int]()
            selectedIndexs.append(indexes)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //取消按钮点击事件
    func cancelBtnClick(_ button:UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    //确定按钮点击事件
    func btnClick(_ button:UIButton) {
        print("选中项的索引为：", selectedIndexs)
        print("选中项的值为：")
        for i in 0...selectedIndexs.count{
            for index in selectedIndexs[i]{
                print(sectionsArray[i][index].name!)
            }
        }
    }
}

extension ChoiceUserViewController:UITableViewDataSource{
    //设置一个分区
     func numberOfSections(in tableView: UITableView) -> Int {
        return collation?.sectionTitles.count ?? 0
    }
    //每个分区返回的Cell数
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsArray[section].count
    }
    //创建每个Cell显示的内容
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let identify:String = "Cell"
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
}
extension ChoiceUserViewController:UITableViewDelegate{
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
}
