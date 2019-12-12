//
//  JokeCellTests.swift
//  ChuckNorrisAppTests
//
//  Created by Глеб Николаев on 11.12.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import XCTest
@testable import ChuckNorrisApp

class JokeCellTests: XCTestCase {
    
    var cell: JokeCell!

    override func setUp() {
        // Работаем через сториборд чтобы иметь возможность обратится к правильной ячейке, так как мы создавали интерфейс через Storyboard, а не код
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: JokesViewController.self)) as! JokesViewController
        controller.loadViewIfNeeded()
        
        let tableView = controller.tableView
        let fakeDataSource = FakeDataSource()
        tableView?.dataSource = fakeDataSource

        cell = tableView?.dequeueReusableCell(withIdentifier: JokeCell.reuseId, for: IndexPath(row: 0, section: 0)) as? JokeCell
    }
    
    // Проверяем есть ли у нашей ячейки Label который называется - "cellLabel"
    func testCellHasLabel() {
        XCTAssertNotNil(cell.cellLabel)
    }
    
    // Проверяем есть ли у нашей ячейки ImageView который называется - "cellImagee"
    func testCellHasCellImageView() {
        XCTAssertNotNil(cell.cellImage)
    }
    
    // Проверяем есть ли у нашей ячейки StackView который называется - "cellStackViewForCell"
    func testCellHasStackViewForCell() {
        XCTAssertNotNil(cell.stackViewForCell)
    }
    
    // Проверяем есть ли у нашей ячейки View который называется - "backgroundViewForCell"
    func testCellHasBackgroundViewForCell() {
        XCTAssertNotNil(cell.backgroundViewForCell)
    }
    
    // Проверяем находится ли наш cellLabel внутри View ячейки
    func testCellHasCellLabelInContentView() {
        XCTAssertTrue(cell.cellLabel.isDescendant(of: cell.contentView))
    }
    
    // Проверяем находится ли наш cellImage внутри View ячейки
    func testCellHasImageViewInContentView() {
        XCTAssertTrue(cell.cellImage.isDescendant(of: cell.contentView))
    }
    
    // Проверяем находится ли наш stackView внутри View ячейки
    func testCellHasStackViewForCellInContentView() {
        XCTAssertTrue(cell.stackViewForCell.isDescendant(of: cell.contentView))
    }
    
    // Проверяем находится ли наш backgroundViewForCell внутри View ячейки
    func testCellHasBackgroundViewForCellInContentView() {
        XCTAssertTrue(cell.backgroundViewForCell.isDescendant(of: cell.contentView))
    }

}

// Делаем расширение где создадим фейковый Data Source, так как нам непринципаиально что в нем будет, нам главное добраться до ячейки
extension JokeCellTests {
    
    // ПРИМЕЧАНИЕ: Наследуемся от NSObject для того чтобы иметь возможность работать с таблицей
    // ПРИМЕЧАНИЕ 2: Если не прописать наследование от NSObject, то возникнет масса ошибок
    class FakeDataSource: NSObject, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    
    }
}
