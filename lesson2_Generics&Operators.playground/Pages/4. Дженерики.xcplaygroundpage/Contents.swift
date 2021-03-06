/*:

 # Дженерики
 ## Кто такие
 Дженерик, в контексте Swift – это прежде всего некоторый набор  **кода**:
 - функция
 - класс
 - структура
 - перечисление,

 работающий с широким кругом типов, ограниченным разработчиком.

 \
 Ярким примером дженерик-сущностей являются: `Array` и `Optional`.

 &nbsp;
 ## Какие проблемы решают
 ### Одна операция - много типов
 Пусть нужно произвести сложение типов:
 - `Int`;
 - `Double`;

 \
 Наивным решением будет написать методы следующего вида:
 */

import Foundation

/// Возвращает результат арифметического сложения двух целочисленных значений
/// - Parameters:
///   - lhs: Слагаемое
///   - rhs: Слагаемое
/// - Returns: Результат арифметического сложения
func addIntegers(_ lhs: Int, _ rhs: Int) -> Int {
	lhs + rhs
}

addIntegers(1, 1)

/// Возвращает результат арифметического сложения двух чисел с плавающей запятой
/// - Parameters:
///   - lhs: Слагаемое
///   - rhs: Слагаемое
/// - Returns: Результат арифметического сложения
func addDoubles(_ lhs: Double, _ rhs: Double) -> Double {
	lhs + rhs
}

addDoubles(2, 2)

/*:
 Чуть менее наивным будет сделать перегрузку:
 ````
 func addValues(_ lhs: String, _ rhs: String) -> String { }

 func addValues(_ lhs: Int, _ rhs: Int) -> Int { }
 ````

 Выглядит, как одинаковые сигнатуры + одинаковый код внутри. Хочется сократить.

 Как здесь поможет дженерик? **Дженерик функцией**.
 С ее помощью становится возможным объявить логику, которая будет
 пытаться сложить значения любого типа, поддерживающие операцию сложения.
 */

/// Возвращает результат сложения двух значение типов, поддерживающих сложение
/// - Parameters:
///   - lhs: Слагаемое
///   - rhs: Слагаемое
/// - Returns: Результат сложения
func addValues<T: AdditiveArithmetic> (_ lhs: T, _ rhs: T) -> T {
	lhs + rhs
}

addValues(3, 4)
addValues(4.4, 5.5)

/*:
 `<T: AdditiveArithmetic>` здесь – Generic Constraint - ограничение дженерик-типа, уточняющее
 круг объектов, для которых доступна проектируемая бизнес-логика.

 ### T
 `Т` в сигнатуре приведенной выше функции является типом-плейсхолдером.
 Это значит, что в момент вызова дженерик-кода, он может принять любой тип вместо `Т`
 с оговорками на Generic Constraints.
 Вместе с тем, все параметры вызываемой функции должны быть заполнены значениями
 одного типа `T`, что бы он ни представлял.
 Фактический тип, подставляемый всесто `T`, определяется на каждом вызове.

 NB - можно записать несколько параметров-дженериков с помощью `<T, U, V>`, к примеру:
 */

func addValue<Key, Value>(_ key: Key, value: Value) -> [Key: Value]  {
	return [key: value]
}

/*:
 ### Тип, работающий с любым типом

 Как и массив, словарь или опционал, дженерик тип является оберткой над любым типом, который туда
 можно завернуть.
 Попробуем переписать пример со стеком из книжки свифт.
 */

struct Stack<Element> {

	var container: [Element] = [Element]()

	mutating func push(_ element: Element) {
		container.append(element)
	}

	mutating func push(_ elements: Element...) {
		elements.forEach {
			container.append($0)
		}
	}

	mutating func pop() -> Element? {
		guard !container.isEmpty else {
			return nil
		}
		return container.removeLast()
	}
}

var stack = Stack<NSDecimalNumber>()
var decimal0 = NSDecimalNumber(integerLiteral: 5)
var decimal1 = NSDecimalNumber(integerLiteral: 2)
var decimal2 = NSDecimalNumber(integerLiteral: 6)
stack.push(decimal0, decimal1, decimal2)
stack.pop()

/*:
 Как видно, с плейсхолдерным типом все также, как и в сигнатуре функции. Если хотим использовать
 любой тип под дженерик констрейнтом, то этот тип (`Element`) в данном случае, как бы каскадируется
 на весь остальной код, попадая в типы аргументов функций и типы переменных.
 Таким образом достигается поддержка джнерика внутри области объявления кастомного типа.

 ### Расширение Дженериков

 Расширяется также, как и обычный тип, кроме того, что плейсхолдерный тип доступен в расширении также,
 как и в области объявления.
 */

extension Stack {

	var head: Element? {
		guard !isEmpty
		else {
			return nil
		}

		return container.last
	}

	var isEmpty: Bool {
		container.isEmpty
	}

}

/*:
 ### Ограничения типов
 Ограничивают плейсхолженый тип группой определенных типов:
 - поддерживающих схожий или;
 - определенный разработчиком функционал;
 - наследующихся от определенного класса;

 Пример – Словарь. Ключ словаря должен быть уникален по своей природе. Такое одстигается за счет
 хэщирования ключа. Таким образом словарь принимает в качестве ключа значение, которое реализует
 протокол `Hashable`:

 [Apple Github/Swft/stdlib/Dictionary/Key: Hashable (строка 389)](https://github.com/apple/swift/blob/d1eabf182c7c1abf36b28b111ec98c0ca5168efe/stdlib/public/core/Dictionary.swift#L389)

 Суть такова:
 - без этого ограничения словарь не сможет обеспечить уникальности ключей
 - реализовать протокол `Hashable` может кастомный тип ~> больше гибкости при выборе типа ключа

 Таким образом ограничения дженерик-типов позволяют уточнить ожидания разработчика АПИ от
 пользователя через подобный контракт. Строго говоря, это касается не только Словарей или иных
 стандартных типов Swift, принимающих в себя дженерик-типы.
 Любой кастомный тип также может принимать в себя дженерик и обладать ограничениями на дженерик-тип.

 Создадим протокол, создающий номинальные ограничения для дженерик-типа:
 - /// `Generic constraint, ограничивающий типы на вход только теми, которые поддерживают умножение`
 - /// `public protocol GenericConstraint: Numeric { }`\
 - см. стр. [GenericConstraint](Generic%20Constraint)

 Пусть `х` = структура, оборачивающая целое число, подчиняющаяся этому протоколу:
 - см. стр. [IntWrapper](Int%20Wrapper)

 Создадим функцию, принимающую на вход некоторый тип, подчиняющийся нашему протоколу.
 */

/// Возвращает трансформированную копию коллекции с перемноженными элементами
/// - Returns: коллекция, в которой каждый элемент умножен на 2
func iterateAndMultiply<T: GenericConstraint>(_ input: [T]) -> [T] {
	input.map { $0 * 2 }
}

/// Мок под дженерик-ограничение
let x = IntWrapper(integerLiteral: 4)

/// Массив таких объектов
var objectArray = [IntWrapper]()
(0...10).forEach { _ in objectArray.append(x) }

/// Применение функции
var multiplied = iterateAndMultiply(objectArray)

/// Причем к примеру Int уже туда подойдет
var intArray = [Int]()
(0...10).forEach { intArray.append($0) }

// Global function 'iterateAndMultiply' requires that 'Int' conform to 'GenericConstraint'
// `var multipliedInts = iterateAndMultiply(intArray)`

//: [Next](@next)
