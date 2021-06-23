//
//  Sample.swift
//  LearnWCDB
//
//  Created by ice on 2021/6/22.
//

import Foundation
import WCDBSwift

class Sample: TableCodable {
    var identifier: Int? = nil
    var description: String? = nil
    var name: String? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Sample
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case description
        case name
        
        // 设置主键
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [identifier: ColumnConstraintBinding(isPrimary: true)]
        }
    }
}

class DatabaseManager {
    static let `default` = DatabaseManager()
    var dataBaseQueue = DispatchQueue(label: "com.vvWork.database.queue")
    private var database: Database?
    
    // 初始化数据库
    func initDataBase() {
        let cachePath = NSHomeDirectory() + "/Documents/DataBase"
        print(cachePath)
        database = Database(withPath: cachePath)
        
        do {
            try database?.create(table: "sampleTable", of: Sample.self)
        } catch let error {
            print("db create table error: \(error)")
        }
    }
    
    // 增
    func insert(object: Sample?) {
        insertAndREplace(object: object)
    }
    
    // 删
    func deletate(identifier: Int?) {
        deletateWith(identifier: identifier)
    }
    
    // 改
    func update(object: Sample?) {
        updateWithObj(object: object)
    }
    
    // 查
    func search() -> [Sample] {
        var objects: [Sample]? = []
        do {
            objects = try database?.getObjects(fromTable: "sampleTable")
        } catch let error {
            print("db search error: \(error)")
        }
        return objects ?? []
    }
}

extension DatabaseManager {
    // 插入，如果已经存在继续插入会失败
    func insertNew(object: Sample?) {
        guard let object = object else {
            return
        }
        do {
            try database?.insert(objects: object, intoTable: "sampleTable")
        } catch let error {
            print("db save error: \(error)")
        }
    }
    
    // 插入，如果存在继续插入会更加主键更新值
    func insertAndREplace(object: Sample?) {
        guard let object = object else {
            return
        }
        do {
            try database?.insertOrReplace(objects: object, intoTable: "sampleTable")
        } catch let error {
            print("db save error: \(error)")
        }
    }
}

extension DatabaseManager {
    // 删除指定的identifier行
    func deletateWith(identifier: Int?) {
        guard let identifier = identifier else {
            return
        }
        do {
            let table: Table<Sample>? = try database?.getTable(named: "sampleTable")
            try table?.delete(where: Sample.Properties.identifier == identifier)
        } catch let error {
            print("db delete error: \(error)")
        }
    }
    
    // 删除表中所有identifier 大于 1 的行数据
    func deleteOrd() {
        do {
            let table: Table<Sample>? = try database?.getTable(named: "sampleTable")
            try table?.delete(where: Sample.Properties.identifier > 1)
        } catch let error {
            print("db delete error: \(error)")
        }
    }
    
    // 删除表中identifier降序排列后的前2行数据
    func deleteOrderBy() {
        do {
            try database?.delete(fromTable: "sampleTable", where: Sample.Properties.description.isNotNull(), orderBy: [Sample.Properties.identifier.asOrder(by: .descending)], limit: 2)
        } catch let error {
            print("db delete error: \(error)")
        }
    }
    
    // 删除表中所有内容
    func deleteAll() {
        do {
            try database?.delete(fromTable: "sampleTable")
        } catch let error {
            print("db deleteAll error: \(error)")
        }
    }
    
    func deleteTable() {
        do {
            try database?.drop(table: "sampleTable")
        } catch let error {
            print("db deleteTable error: \(error)")
        }
    }
}

extension DatabaseManager {
    // 将 sampleTable 中所有 identifier 大于 1 且 description 字段不为空 的行的 description 字段更新为 "update"
    func updateWithObj(object: Sample?) {
        guard let object = object else {
            return
        }
        do {
            try database?.update(table: "sampleTable", on: Sample.Properties.description, with: object, where: Sample.Properties.identifier > 1 && Sample.Properties.description.isNotNull())
        } catch let error {
            print("db update error: \(error)")
        }
    }
    
    // 将 sampleTable 中前三行的 description 字段更新为 "update"
    func updateWithLimit(object: Sample?) {
        guard let object = object else {
            return
        }
        do {
            try database?.update(table: "sampleTable", on: Sample.Properties.description, with: object, limit: 3)
        } catch let error {
            print("db update error: \(error)")
        }
    }
    
    // 将 sampleTable 中前三行的 description 字段值更新为 "6666666"
    func updateWithRow1() {
        let row: [ColumnEncodable] = ["6666666"]
        do {
            try database?.update(table: "sampleTable", on: Sample.Properties.description, with: row, limit: 3)
        } catch let error {
            print("db update error: \(error)")
        }
    }
    // // 将 sampleTable 中所有 identifier 大于 1 且 description 字段不为空 的行的 description 字段更新为 "6666666"
    func updateWithRow2() {
        let row: [ColumnEncodable] = ["6666666"]
        do {
            try database?.update(table: "sampleTable", on: Sample.Properties.description, with: row, where: Sample.Properties.identifier > 1 && Sample.Properties.description.isNotNull() )
        } catch let error {
            print("db update error: \(error)")
        }
    }
}

extension DatabaseManager {
    // 获取表中所有的数据
    func getAll() -> [Sample] {
        var objects: [Sample]? = []
        do {
            objects = try database?.getObjects(fromTable: "sampleTable")
        } catch let error {
            print("db getObjects error: \(error)")
        }
        return objects ?? []
    }
    
    func getWithWhere() -> [Sample] {
        var objects: [Sample]? = []
        do {
            objects = try database?.getObjects(fromTable: "sampleTable", where: Sample.Properties.identifier == 1 || Sample.Properties.identifier == 4)
        } catch let error {
            print("db getObjects error: \(error)")
        }
        return objects ?? []
    }
    
    // 返回 sampleTable 中 identifier 最大的行的数据
    func getMax() -> Sample {
        var object: Sample?
        do {
            object = try database?.getObject(fromTable: "sampleTable",
                                             orderBy: [Sample.Properties.identifier.asOrder(by: .descending)])
        } catch let error {
            print("db getObjects error: \(error)")
        }
        return object ?? Sample()
    }
}
