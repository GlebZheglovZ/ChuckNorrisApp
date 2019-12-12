//
//  JokesViewControllerTests.swift
//  ChuckNorrisAppTests
//
//  Created by Глеб Николаев on 09.12.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import XCTest
// Импортируем наш модуль ChuckNorrisApp
@testable import ChuckNorrisApp

class JokesViewControllerTests: XCTestCase {
    
    // Создаем объект типа JokesViewController (System Under Test)
    var sut: JokesViewController!
    var tableView: UITableView!
    var cell: JokeCell!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: JokesViewController.self)) as? JokesViewController
        sut.loadViewIfNeeded() //После срабатывания метода loadViewIfNeeded, загружается TableView
        tableView = sut.tableView
        tableView.dataSource = sut
    }

    override func tearDown() {
        sut = nil
        tableView = nil
        cell = nil
        super.tearDown()
    }
    
    // Проверяем действительно ли наш вьюконтроллер после загрузки имеет внутри себя tableView
    func testWhenViewIsLoadedTableViewNotNil() {
        XCTAssertNotNil(sut.tableView) // Проверяем что tableView не nil
    }
    
    func testWhenViewIsLoadedActivityIndicatorNotNil() {
        XCTAssertNotNil(sut.activityIndicator)
    }
    
    func testWhenViewIsLoadedLoadButtonNotNil() {
        XCTAssertNotNil(sut.loadButton)
    }
    
    func testWhenViewIsLoadedNumberOfJokesTextFieldNotNil() {
        XCTAssertNotNil(sut.numberOfJokesTextField)
    }
    
    func testWhenViewIsLoadedNetworkManagerExists() {
        XCTAssertNotNil(sut.networkManager)
    }
    
    // Проверяем что при загрузке нашего контроллера делегат для нашего tableView будет установлен
    func testWhenViewIsLoadedTableViewDelegateIsJokesViewController() {
        XCTAssertTrue(sut.tableView.delegate is JokesViewController)
    }
    
    // Проверяем что при загрузке нашего контроллера датасорс для нашего tableView будет установлен
    func testWhenViewIsLoadedTableViewDataSourceIsJokesViewController() {
        XCTAssertTrue(sut.tableView.dataSource is JokesViewController)
    }
    
    // Проверяем что делегатом датасорсом нашего тейблвью является наш JokesViewController (Вспомогательный тест)
    func testWhenViewIsLoadedTableViewDelegateEqualsTableViewDataSource() {
        XCTAssertEqual(sut.tableView.delegate as? JokesViewController, sut.tableView.dataSource as? JokesViewController)
    }
    
    // Проверяем количество секций с шутками в нашем tableView (В нашем случае должна быть всего 1 секция)
    func testNumberOfSectionsIsOne() {
        let numberOfSections = sut.tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 1)
    }
    
    // Проверяем что количество шуток в массиве равно количеству строк в нулевой (единственной) секции нашего tableView
    func testNumberOfRowsInSectionZero() {
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0) // Когда мы обращаемся к tableView.numberOfRows мы кешируем данные по которым стоится таблица
        sut.receivedJokes.append(Joke(joke: "Foo")) // Добавляем элемент в массив receivedJokes
        sut.tableView.reloadData() // Обновляем таблицу чтобы избавиться от закешированных данных в tableView
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        sut.receivedJokes.append(Joke(joke: "Bar"))
        sut.tableView.reloadData()
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 2)
    }
    
    // REFACTORING (Выносим общую логику)
    func createJokeAndAppendItToArrayWithReloadingData() {
        // Создаем объект типа Joke
        let joke = Joke(joke: "Foo")
        // Добавляем объект joke в массив receivedJokes
        sut.receivedJokes.append(joke)
        // Обновляем tableView, которая формируется на основе значений массива receivedJokes
        sut.tableView.reloadData()
        // Вызываем метод cellForRow чтобы спровоцировать срабатываение методов нашей ячейки
        cell = sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? JokeCell
    }
    
    // Проверяем что метод CellForRowAtIndexPath возвращает не nil
    func testCellForRowAtIndexPathIsNotNil() {
        createJokeAndAppendItToArrayWithReloadingData()
        XCTAssertNotNil(cell)
    }
    
    // Проверяем какую ячейку мы получаем в методе cellForRowAtIndexPath
    // Мы проверяем что метод CellForRowAtIndexPath возвращает именно JokeCell, а не какой то другой тип
//    func testCellForRowAtIndexPathReturnsTaskCell() {
//        createJokeAndAppendItToArrayWithReloadingData()
//        XCTAssertTrue(cell is JokeCell)
//    }
    
    // Пишем тест который проверяет что cellForRowAtIndexPath переиспользует нашу ячейку
    func testCellForRowAtIndexPathDequeuesCellFromTableView() {
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)

        // Добавляем объект
        sut.receivedJokes.append(Joke(joke: "Foo"))

        // Отрисовываем таблицу
        mockTableView.reloadData()

        // Попробуем получить ячейку, чтобы отработал метод dequeueReusableCell
        let _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! JokeCell

        // Проверяем изменился ли у нас флаг cellIsDequeued после срабатывания dequeueReusableCell
        XCTAssertTrue(mockTableView.cellIsDequeued)
    }
    
    // Проверяем срабатывает ли у нас метод ячейки JokeCell
    func testCellForRowInSectionZeroCallsSetupCellMethod() {
        createJokeAndAppendItToArrayWithReloadingData()
        
        // Если при срабатывании reloadData у нас срабатывает метод ячейки мы сравниваем шутку которую мы создали с той которая поместилась в класс ячейки
        
        XCTAssertEqual(cell.cellLabel.text, "Foo".convertSpecialCharacters())
        XCTAssertEqual(cell.cellImage.image, UIImage(named: "chuck"))
    }
    
    func testCellForRowCallsSetupBackgroundMethod() {
        createJokeAndAppendItToArrayWithReloadingData()
        XCTAssertEqual(cell.backgroundViewForCell.backgroundColor, UIColor.orange)
        XCTAssertEqual(cell.backgroundViewForCell.layer.cornerRadius, 15)
        XCTAssertEqual(cell.backgroundViewForCell.layer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(cell.backgroundViewForCell.layer.shadowOffset, CGSize(width: 1, height: 1))
        XCTAssertEqual(cell.backgroundViewForCell.layer.shadowOpacity, 1.0)
        XCTAssertEqual(cell.backgroundViewForCell.layer.shadowRadius, 5)
        XCTAssertEqual(cell.backgroundViewForCell.layer.masksToBounds, false)
    }
    
    func testCellForRowCallsApplyAnimationForAppearingMethod() {
        createJokeAndAppendItToArrayWithReloadingData()
        XCTAssertEqual(cell.cellImage.alpha, 1)
        XCTAssertEqual(cell.cellLabel.alpha, 1)
        XCTAssertEqual(cell.backgroundViewForCell.alpha, 1)
    }
    
    func testWhenTextFieldIsLoadedDelegateIsJokesViewController() {
        XCTAssertTrue(sut.numberOfJokesTextField.delegate is JokesViewController)
    }
    
    func testTextFieldKeyboardType() {
        XCTAssertEqual(sut.numberOfJokesTextField.keyboardType, UIKeyboardType.numberPad)
    }
    
}

extension JokesViewControllerTests {
    class MockTableView: UITableView {
        var cellIsDequeued = false
        
        static func mockTableView(withDataSource dataSource: UITableViewDataSource) -> MockTableView {
            // Создаем MockTableView с размерами
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 375, height: 658), style: .plain)
            mockTableView.dataSource = dataSource
            // Регистрируем ячейку
            let nib = UINib(nibName: String(describing: JokeCell.self), bundle: nil)
            mockTableView.register(nib, forCellReuseIdentifier: JokeCell.reuseId)
            return mockTableView
        }
        
        //Переопределеяем метод для проверки что наша ячейка переиспользуется
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellIsDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier,
                                             for: indexPath)
        }
    }
}
