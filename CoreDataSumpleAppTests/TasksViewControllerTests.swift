//
//  TasksViewControllerTests.swift
//  CoreDataSumpleAppTests
//
//  Created by TakahashiKotomi on 2023/11/26.
//

import UIKit
import CoreData
import XCTest
@testable import CoreDataSumpleApp

final class TasksViewControllerTests: XCTestCase {
    var viewController: TasksViewController!
    
    override func setUp() {
        super.setUp()
        // テスト用のViewControllerインスタンスを生成
        viewController = TasksViewController()
    }
    
    // tearDown()メソッドは各テストケースの実行後に呼び出される
    // テスト間で共有される状態やリソースがないことを保証
    // => 各テストは互いに独立して実行される
    override func tearDown() {
        // テストで使用されたviewControllerインスタンスへの参照を解放
        viewController = nil
        super.tearDown()
    }
    
    // getContext()メソッドがNSManagedObjectContextを返すことを確認
    private func testGetContext() {
        // getContext()メソッドを呼び出し
        let context = viewController.getContext()
        
        // 戻り値contextはNSManagedObjectContextのインスタンスであることを確認
        XCTAssertNotNil(context, "Contextは必ず存在する")
        XCTAssertTrue(context is NSManagedObjectContext, "contextはNSManagedObjectContext型のインスタンスです。")
    }
}
